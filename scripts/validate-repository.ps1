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
    $seenIds = @{}
    $principleCount = 0

    foreach ($file in $principleFiles) {
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
            if ($seenIds.ContainsKey($id)) {
                throw "Duplicate principle ID $id in $($file.Name) and $($seenIds[$id])."
            }
            $seenIds[$id] = $file.Name
            $principleCount++

            $values = @{}
            foreach ($field in $requiredFields) {
                $escapedField = [regex]::Escape($field)
                $match = [regex]::Match(
                    $body,
                    "(?m)^- \*\*${escapedField}:\*\*[ \t]+(?<value>.+)$"
                )
                if (-not $match.Success) {
                    throw "$id in $($file.Name) is missing required metadata: $field."
                }
                $values[$field] = $match.Groups["value"].Value.Trim()
            }

            if ($values["Status"] -ne "Draft") {
                throw "$id in $($file.Name) must have Draft status."
            }
            if (
                $values["Owner and ratification"] -notmatch
                    "(?i)repository owner alone ratifies"
            ) {
                throw "$id in $($file.Name) must state that the repository owner alone ratifies it."
            }
            if (
                $values["Legacy inputs"] -ne "none" -and
                $values["Legacy inputs"] -notmatch '^`[^`]+`(?:, `[^`]+`)*$'
            ) {
                throw "$id in $($file.Name) must list backticked Legacy inputs IDs or none."
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
