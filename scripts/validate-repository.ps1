param(
    [string]$PrinciplesPath = "principles",
    [switch]$SkipTrackedTextValidation
)

$ErrorActionPreference = "Stop"

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw "Repository root could not be resolved."
}

Push-Location $root
try {
    if (-not $SkipTrackedTextValidation) {
        $textFiles = @(git grep --cached -Il -e "" -- .)
        if ($LASTEXITCODE -ne 0) {
            throw "Tracked text files could not be enumerated."
        }

        $carriageReturn = [string][char]13
        $filesWithCarriageReturns = @(git grep --cached -Il -e $carriageReturn -- .)
        if ($LASTEXITCODE -gt 1) {
            throw "Tracked text files could not be checked."
        }

        if ($filesWithCarriageReturns) {
            throw "Tracked text files must use LF endings: $($filesWithCarriageReturns -join ', ')"
        }
    }

    $resolvedPrinciplesPath = if ([IO.Path]::IsPathRooted($PrinciplesPath)) {
        $PrinciplesPath
    }
    else {
        Join-Path $root $PrinciplesPath
    }

    if (-not (Test-Path -LiteralPath $resolvedPrinciplesPath -PathType Container)) {
        throw "Principles path does not exist: $resolvedPrinciplesPath"
    }

    $principleFiles = @(
        Get-ChildItem -LiteralPath $resolvedPrinciplesPath -Filter "*.md" -File |
            Where-Object Name -ne "README.md"
    )
    if (-not $principleFiles) {
        throw "No principle files found in $resolvedPrinciplesPath."
    }

    $requiredFields = @(
        "Status",
        "Principle",
        "Rationale",
        "Verification",
        "Owner and ratification",
        "Handoff",
        "Legacy inputs"
    )
    $idPrefixesByFile = @{
        "business.md"                  = "PROD-BUS-"
        "compliance.md"                = "PROD-COMP-"
        "content-operations.md"        = "PROD-CONTENT-"
        "discovery-and-experiments.md" = "PROD-DISC-"
        "metrics.md"                   = "PROD-MET-"
        "planning-and-delivery.md"     = "PROD-PLAN-"
        "release-decisions.md"         = "PROD-REL-"
        "strategy.md"                  = "PROD-STRAT-"
    }
    $legacyInputsBySource = @{
        "accessibility"     = @(1..7)
        "ai-products"      = @(1..8)
        "business"         = @(1, 2, 3, 4, 5, 6)
        "compliance"       = @(1, 2, 3, 4, 5, 6, 7, 8)
        "data-analytics"   = @(1, 2, 3, 4, 5, 6, 7)
        "documentation"    = @(1..7)
        "featuring"        = @(1..7)
        "localization"     = @(1..9)
        "process"          = @(1..7)
        "project-planning" = @(1, 2, 3, 4, 5, 6, 7)
        "security"         = @(1..8)
    }
    $legacySourceSlugs = @($legacyInputsBySource.Keys)
    $legacyInputPattern = '^`studio-legacy:(?:' +
        (($legacySourceSlugs | ForEach-Object { [regex]::Escape($_) }) -join "|") +
        '):[1-9][0-9]*`(?:, `studio-legacy:(?:' +
        (($legacySourceSlugs | ForEach-Object { [regex]::Escape($_) }) -join "|") +
        '):[1-9][0-9]*`)*$'
    $seenIds = @{}
    $principleCount = 0

    foreach ($file in $principleFiles) {
        if (-not $idPrefixesByFile.ContainsKey($file.Name)) {
            throw "$($file.Name) has no registered principle ID namespace."
        }
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $blocks = [regex]::Matches(
            $content,
            "(?ms)^## (?<id>PROD-[A-Z]+-[0-9]{3}):[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)"
        )
        if ($blocks.Count -eq 0) {
            throw "$($file.Name) contains no valid principle headings."
        }
        $headingCount = [regex]::Matches($content, "(?m)^## ").Count
        if ($headingCount -ne $blocks.Count) {
            throw "$($file.Name) contains a second-level heading without a valid principle ID."
        }

        foreach ($block in $blocks) {
            $id = $block.Groups["id"].Value
            $body = $block.Groups["body"].Value
            if (-not $id.StartsWith($idPrefixesByFile[$file.Name])) {
                throw "$id in $($file.Name) must use the $($idPrefixesByFile[$file.Name]) namespace."
            }
            if ($seenIds.ContainsKey($id)) {
                throw "Duplicate principle ID $id in $($file.Name) and $($seenIds[$id])."
            }
            $seenIds[$id] = $file.Name
            $principleCount++

            $values = @{}
            foreach ($field in $requiredFields) {
                $escapedField = [regex]::Escape($field)
                $matches = [regex]::Matches(
                    $body,
                    "(?m)^- \*\*${escapedField}:\*\*[ \t]+(?<value>.+)$"
                )
                if ($matches.Count -eq 0) {
                    throw "$id in $($file.Name) is missing required metadata: $field."
                }
                if ($matches.Count -ne 1) {
                    throw "$id in $($file.Name) must contain exactly one $field field."
                }
                $values[$field] = $matches[0].Groups["value"].Value.Trim()
            }

            if ($values["Status"] -ne "Draft") {
                throw "$id in $($file.Name) must have Draft status."
            }
            if (
                $values["Owner and ratification"] -notmatch
                    '^Product owns [^;]+; the repository owner alone ratifies this principle, and this proposal remains Draft\.$'
            ) {
                throw "$id in $($file.Name) must use the exact owner-only Draft ratification statement."
            }
            if (
                $values["Legacy inputs"] -ne "none" -and
                $values["Legacy inputs"] -notmatch $legacyInputPattern
            ) {
                throw "$id in $($file.Name) must list resolvable backticked Studio legacy input IDs or none."
            }
            if ($values["Legacy inputs"] -ne "none") {
                $legacyInputs = [regex]::Matches(
                    $values["Legacy inputs"],
                    'studio-legacy:(?<source>[a-z-]+):(?<number>[1-9][0-9]*)'
                )
                foreach ($legacyInput in $legacyInputs) {
                    $source = $legacyInput.Groups["source"].Value
                    $number = [int]$legacyInput.Groups["number"].Value
                    if ($legacyInputsBySource[$source] -notcontains $number) {
                        throw "$id in $($file.Name) references studio-legacy:${source}:${number}, which does not resolve to a mapped Studio legacy principle."
                    }
                }
            }
        }
    }

    $textSummary = if ($SkipTrackedTextValidation) {
        "tracked-text validation skipped"
    }
    else {
        "$($textFiles.Count) tracked text files use LF endings"
    }
    Write-Host "Repository validation passed: $principleCount unique Draft principles; $textSummary."
}
finally {
    Pop-Location
}

exit 0
