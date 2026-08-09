param(
    [string]$PrinciplesPath = "principles",
    [string]$DecisionRecordPath = "docs/architecture/0001-ratify-product-principles.md",
    [switch]$SkipTrackedTextValidation
)

$ErrorActionPreference = "Stop"

function Throw-ValidationError {
    param(
        [string]$Code,
        [string]$Message
    )

    throw "[$Code] $Message"
}

function Get-NormalizedSha256 {
    param([string]$Text)

    $normalized = ($Text -replace "`r`n", "`n").TrimEnd([char]10) + "`n"
    $sha256 = [Security.Cryptography.SHA256]::Create()
    try {
        return (($sha256.ComputeHash([Text.Encoding]::UTF8.GetBytes($normalized)) |
            ForEach-Object { $_.ToString("x2") }) -join "")
    }
    finally {
        $sha256.Dispose()
    }
}

function Get-GitTextBlob {
    param(
        [string]$Commit,
        [string]$Path
    )

    $lines = @(& git show "${Commit}:${Path}" 2>$null)
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_UNAVAILABLE" `
            -Message "Could not read $Path from immutable source commit $Commit."
    }
    return ($lines -join "`n") + "`n"
}

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
            Where-Object Name -ne "README.md" |
            Sort-Object Name
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
    # PR #4's merge contains the final Draft catalog from source PRs #3 and #4.
    $sourceCatalogCommit = "b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5"
    & git cat-file -e "${sourceCatalogCommit}^{commit}" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_UNAVAILABLE" `
            -Message "Immutable source commit $sourceCatalogCommit is unavailable; fetch repository history before validation."
    }
    $baseBranchName = if ($env:GITHUB_BASE_REF) {
        $env:GITHUB_BASE_REF
    }
    else {
        "main"
    }
    $baseBranchRef = "refs/remotes/origin/$baseBranchName"
    & git rev-parse --verify $baseBranchRef 1>$null 2>$null
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_UNAVAILABLE" `
            -Message "Independent base reference $baseBranchRef is unavailable; fetch repository history before validation."
    }
    & git merge-base --is-ancestor $sourceCatalogCommit $baseBranchRef
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_COMMIT" `
            -Message "Source PR #4 merge commit $sourceCatalogCommit must come from the independent $baseBranchRef history."
    }
    & git merge-base --is-ancestor $sourceCatalogCommit HEAD
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_COMMIT" `
            -Message "Source PR #4 merge commit $sourceCatalogCommit must be an ancestor of the validated change."
    }

    $sourceTreePaths = @(
        & git ls-tree -r --name-only $sourceCatalogCommit -- principles
    )
    if ($LASTEXITCODE -ne 0) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_UNAVAILABLE" `
            -Message "Could not enumerate the immutable Product catalog from $sourceCatalogCommit."
    }
    $sourcePrinciplePaths = @(
        $sourceTreePaths |
            Where-Object {
                $_ -match '^principles/[^/]+\.md$' -and
                $_ -ne "principles/README.md"
            } |
            Sort-Object
    )

    $expectedCatalogByFile = [ordered]@{}
    $expectedFileSemanticHashes = @{}
    $sourceCatalogLines = @()
    $sourcePrincipleCount = 0
    foreach ($sourcePath in $sourcePrinciplePaths) {
        $fileName = [IO.Path]::GetFileName($sourcePath)
        if (-not $idPrefixesByFile.ContainsKey($fileName)) {
            Throw-ValidationError `
                -Code "RATIFICATION_SOURCE_CATALOG" `
                -Message "Immutable source catalog contains an unregistered path: $sourcePath."
        }

        $sourceContent = Get-GitTextBlob `
            -Commit $sourceCatalogCommit `
            -Path $sourcePath
        $sourceBlocks = [regex]::Matches(
            $sourceContent,
            "(?ms)^## (?<id>PROD-[A-Z]+-[0-9]{3}):[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)"
        )
        $sourceHeadingCount = [regex]::Matches(
            $sourceContent,
            "(?m)^## "
        ).Count
        if ($sourceBlocks.Count -eq 0 -or $sourceBlocks.Count -ne $sourceHeadingCount) {
            Throw-ValidationError `
                -Code "RATIFICATION_SOURCE_CATALOG" `
                -Message "Immutable source catalog path $sourcePath is not structurally valid."
        }

        $sourceSemanticFile = [regex]::Replace(
            $sourceContent,
            '(?m)^- \*\*Status:\*\*[^\r\n]*(?:\r?\n|$)',
            ""
        )
        $expectedFileSemanticHashes[$fileName] = Get-NormalizedSha256 `
            -Text $sourceSemanticFile
        $expectedCatalogByFile[$fileName] = [ordered]@{}

        foreach ($sourceBlock in $sourceBlocks) {
            $sourceId = $sourceBlock.Groups["id"].Value
            $sourceBody = $sourceBlock.Groups["body"].Value
            $sourceStatus = [regex]::Match(
                $sourceBody,
                '(?m)^- \*\*Status:\*\*[ \t]+(?<value>.+)$'
            ).Groups["value"].Value.Trim()
            if (
                -not $sourceId.StartsWith($idPrefixesByFile[$fileName]) -or
                $sourceStatus -ne "Draft"
            ) {
                Throw-ValidationError `
                    -Code "RATIFICATION_SOURCE_CATALOG" `
                    -Message "$sourceId in immutable source catalog path $sourcePath is not an expected Draft Product principle."
            }

            $sourceSemanticBlock = [regex]::Replace(
                $sourceBlock.Value,
                '(?m)^- \*\*Status:\*\*[^\r\n]*(?:\r?\n|$)',
                ""
            )
            $sourceSemanticHash = Get-NormalizedSha256 -Text $sourceSemanticBlock
            $expectedCatalogByFile[$fileName][$sourceId] = $sourceSemanticHash
            $sourceCatalogLines += "$fileName|$sourceId|$sourceSemanticHash"
            $sourcePrincipleCount++
        }
    }
    if ($sourcePrincipleCount -ne 40) {
        Throw-ValidationError `
            -Code "RATIFICATION_SOURCE_CATALOG" `
            -Message "Immutable source commit must contain exactly 40 Product principles; found $sourcePrincipleCount."
    }
    $expectedCatalogSemanticHash = Get-NormalizedSha256 `
        -Text ($sourceCatalogLines -join "`n")
    $seenIds = @{}
    $blocksByFile = @{}
    $contentByFile = @{}
    $semanticHashesById = @{}
    $principleCount = 0

    foreach ($file in $principleFiles) {
        if (-not $idPrefixesByFile.ContainsKey($file.Name)) {
            Throw-ValidationError `
                -Code "PRINCIPLE_CATALOG_FILES" `
                -Message "$($file.Name) is not an expected Product principle catalog path."
        }
        $content = Get-Content -LiteralPath $file.FullName -Raw
        $blocks = [regex]::Matches(
            $content,
            "(?ms)^## (?<id>PROD-[A-Z]+-[0-9]{3}):[^\r\n]*\r?\n(?<body>.*?)(?=^## |\z)"
        )
        if ($blocks.Count -eq 0) {
            Throw-ValidationError `
                -Code "PRINCIPLE_HEADING" `
                -Message "$($file.Name) contains no valid principle headings."
        }
        $headingCount = [regex]::Matches($content, "(?m)^## ").Count
        if ($headingCount -ne $blocks.Count) {
            Throw-ValidationError `
                -Code "PRINCIPLE_HEADING" `
                -Message "$($file.Name) contains a second-level heading without a valid principle ID."
        }
        $blocksByFile[$file.Name] = $blocks
        $contentByFile[$file.Name] = $content

        foreach ($block in $blocks) {
            $id = $block.Groups["id"].Value
            if (-not $id.StartsWith($idPrefixesByFile[$file.Name])) {
                Throw-ValidationError `
                    -Code "PRINCIPLE_ID_NAMESPACE" `
                    -Message "$id in $($file.Name) must use the $($idPrefixesByFile[$file.Name]) namespace."
            }
            if ($seenIds.ContainsKey($id)) {
                Throw-ValidationError `
                    -Code "PRINCIPLE_DUPLICATE_ID" `
                    -Message "Duplicate principle ID $id in $($file.Name) and $($seenIds[$id])."
            }
            $seenIds[$id] = $file.Name
            $principleCount++
        }

        foreach ($block in $blocks) {
            $id = $block.Groups["id"].Value
            $body = $block.Groups["body"].Value
            $values = @{}
            foreach ($field in $requiredFields) {
                $escapedField = [regex]::Escape($field)
                $matches = [regex]::Matches(
                    $body,
                    "(?m)^- \*\*${escapedField}:\*\*[ \t]+(?<value>.+)$"
                )
                if ($matches.Count -eq 0) {
                    Throw-ValidationError `
                        -Code "PRINCIPLE_MISSING_METADATA" `
                        -Message "$id in $($file.Name) is missing required metadata: $field."
                }
                if ($matches.Count -ne 1) {
                    Throw-ValidationError `
                        -Code "PRINCIPLE_DUPLICATE_METADATA" `
                        -Message "$id in $($file.Name) must contain exactly one $field field."
                }
                $values[$field] = $matches[0].Groups["value"].Value.Trim()
            }

            if (
                $values["Owner and ratification"] -notmatch
                    '^Product owns [^;]+; the repository owner alone ratifies this principle, and this proposal remains Draft\.$'
            ) {
                Throw-ValidationError `
                    -Code "PRINCIPLE_RATIFICATION" `
                    -Message "$id in $($file.Name) must preserve the exact owner-only source-proposal Ratification statement."
            }
            if (
                $values["Legacy inputs"] -ne "none" -and
                $values["Legacy inputs"] -notmatch $legacyInputPattern
            ) {
                Throw-ValidationError `
                    -Code "PRINCIPLE_LEGACY_FORMAT" `
                    -Message "$id in $($file.Name) must list resolvable backticked Studio legacy input IDs or none."
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
                        Throw-ValidationError `
                            -Code "PRINCIPLE_LEGACY_UNMAPPED" `
                            -Message "$id in $($file.Name) references studio-legacy:${source}:${number}, which does not resolve to a mapped Studio legacy principle."
                    }
                }
            }
            if ($values["Status"] -ne "Ratified") {
                Throw-ValidationError `
                    -Code "PRINCIPLE_STATUS" `
                    -Message "$id in $($file.Name) must have exactly Ratified status; mixed or unauthorized states are not allowed."
            }

            $semanticBlock = [regex]::Replace(
                $block.Value,
                '(?m)^- \*\*Status:\*\*[^\r\n]*(?:\r?\n|$)',
                ""
            )
            $semanticHashesById[$id] = Get-NormalizedSha256 -Text $semanticBlock
        }
    }

    $expectedFileNames = @($expectedCatalogByFile.Keys | Sort-Object)
    $actualFileNames = @($principleFiles.Name | Sort-Object)
    if (($actualFileNames -join "`n") -ne ($expectedFileNames -join "`n")) {
        Throw-ValidationError `
            -Code "PRINCIPLE_CATALOG_FILES" `
            -Message "Principle catalog paths must be exactly: $($expectedFileNames -join ', ')."
    }

    $semanticCatalogLines = @()
    foreach ($fileName in $expectedCatalogByFile.Keys) {
        $expectedIds = @($expectedCatalogByFile[$fileName].Keys)
        $actualIds = @($blocksByFile[$fileName] | ForEach-Object {
            $_.Groups["id"].Value
        })
        if (($actualIds -join "`n") -ne ($expectedIds -join "`n")) {
            Throw-ValidationError `
                -Code "PRINCIPLE_CATALOG_IDS" `
                -Message "$fileName must preserve the exact catalog IDs and ordering: $($expectedIds -join ', ')."
        }

        $semanticFile = [regex]::Replace(
            $contentByFile[$fileName],
            '(?m)^- \*\*Status:\*\*[^\r\n]*(?:\r?\n|$)',
            ""
        )
        if (
            (Get-NormalizedSha256 -Text $semanticFile) -ne
            $expectedFileSemanticHashes[$fileName]
        ) {
            Throw-ValidationError `
                -Code "PRINCIPLE_SEMANTIC_DRIFT" `
                -Message "$fileName changed outside Status metadata; all source-proposal wording must remain unchanged."
        }

        foreach ($id in $expectedIds) {
            $actualSemanticHash = $semanticHashesById[$id]
            $expectedSemanticHash = $expectedCatalogByFile[$fileName][$id]
            if ($actualSemanticHash -ne $expectedSemanticHash) {
                Throw-ValidationError `
                    -Code "PRINCIPLE_SEMANTIC_DRIFT" `
                    -Message "$id in $fileName changed outside Status metadata; source wording, ownership, handoff, and Legacy inputs must remain unchanged."
            }
            $semanticCatalogLines += "$fileName|$id|$actualSemanticHash"
        }
    }

    $semanticCatalogHash = Get-NormalizedSha256 -Text ($semanticCatalogLines -join "`n")
    if ($semanticCatalogHash -ne $expectedCatalogSemanticHash) {
        Throw-ValidationError `
            -Code "PRINCIPLE_SEMANTIC_DRIFT" `
            -Message "The status-excluded semantic catalog hash does not match the source proposals."
    }

    $resolvedDecisionRecordPath = if ([IO.Path]::IsPathRooted($DecisionRecordPath)) {
        $DecisionRecordPath
    }
    else {
        Join-Path $root $DecisionRecordPath
    }
    if (-not (Test-Path -LiteralPath $resolvedDecisionRecordPath -PathType Leaf)) {
        Throw-ValidationError `
            -Code "RATIFICATION_DECISION_MISSING" `
            -Message "The owner-merge Ratification decision record is missing: $resolvedDecisionRecordPath."
    }

    $decisionRecord = (
        Get-Content -LiteralPath $resolvedDecisionRecordPath -Raw
    ) -replace "`r`n", "`n"
    $ownerAuthorityPattern = '(?ms)^## Ratification\s+This record contains no approval\. If and only if the repository owner merges\s+the pull request that introduces it, that merge is the explicit Ratification\s+act and makes this decision effective\. Reviews, agent-authored commits, green\s+validation, or approval or merge by anyone else do not ratify the catalog\.\s*$'
    if ($decisionRecord -notmatch $ownerAuthorityPattern) {
        Throw-ValidationError `
            -Code "RATIFICATION_APPROVAL_AUTHORITY" `
            -Message "The decision record must make repository-owner merge the sole effective approval and must not imply prior, ambiguous, or non-owner approval."
    }
    $recordBeforeRatification = [regex]::Replace(
        $decisionRecord,
        $ownerAuthorityPattern,
        ""
    )
    if (
        $recordBeforeRatification -match '(?i)\b(?:approved|approval)\b' -or
        $recordBeforeRatification -match
            '(?i)\b(?:catalog|principles?|decision|record)\s+(?:is|are|was|were|has been|have been)\s+ratified\b'
    ) {
        Throw-ValidationError `
            -Code "RATIFICATION_APPROVAL_AUTHORITY" `
            -Message "The Proposed decision record must not claim approval or effective Ratification before repository-owner merge."
    }

    $expectedDecisionHeadings = @(
        "Context",
        "Decision",
        "Evidence required before merge",
        "Consequences",
        "Handoffs",
        "Ratification"
    )
    $actualDecisionHeadings = @(
        [regex]::Matches($decisionRecord, '(?m)^## (?<heading>[^\r\n]+)$') |
            ForEach-Object { $_.Groups["heading"].Value }
    )
    $expectedDecisionIds = @(
        "PROD-STRAT-001", "PROD-STRAT-003",
        "PROD-PLAN-001", "PROD-PLAN-005",
        "PROD-BUS-001", "PROD-BUS-003",
        "PROD-DISC-001", "PROD-DISC-004",
        "PROD-MET-001", "PROD-MET-003",
        "PROD-COMP-001", "PROD-COMP-009",
        "PROD-CONTENT-001", "PROD-CONTENT-009",
        "PROD-REL-001", "PROD-REL-004"
    )
    $actualDecisionIds = @(
        [regex]::Matches(
            $decisionRecord,
            'PROD-[A-Z]+-[0-9]{3}'
        ) |
            ForEach-Object { $_.Value }
    )
    $expectedSourceUrls = @(
        "https://github.com/jrmoulckers/product/pull/3",
        "https://github.com/jrmoulckers/product/pull/4"
    )
    $actualSourceUrls = @(
        [regex]::Matches(
            $decisionRecord,
            'https://github\.com/jrmoulckers/product/pull/[0-9]+'
        ) |
            ForEach-Object { $_.Value }
    )
    $requiredDecisionPatterns = @(
        '(?m)^# 0001: Ratify the Product principle catalog$',
        '(?m)^- \*\*Status:\*\* Proposed$',
        '(?m)^- \*\*Date:\*\* 2026-08-09$',
        '(?m)^- \*\*Owner:\*\* Repository owner$',
        '(?s)Source PR \[#3\].+proposed the 18\s+core Product principles, and source PR\s+\[#4\].+proposed the 22 compliance,\s+content-operations, and release-decision principles\.',
        '(?s)Only the 40 `Status` metadata values change from `Draft` to `Ratified`\. IDs,\s+ordering, paths, principle statements, rationale, verification, ownership and\s+Ratification wording, handoffs, and Legacy inputs remain byte-for-byte\s+semantically unchanged from source PRs #3 and #4\.',
        '(?s)Final owner review confirms the diff contains the 40 status changes,\s+validation wiring, indexes, and this record, with no content or ownership\s+change\.',
        '(?s)Local Windows PowerShell and the GitHub-hosted `ubuntu-latest` PowerShell\s+workflow run `\./scripts/test-validate-repository\.ps1` successfully\.',
        [regex]::Escape($sourceCatalogCommit),
        '(?s)This record creates no package, runtime, template, or new\s+authority\.',
        '(?s)Compliance principles remain governance and qualified-review\s+triggers, not legal advice\.',
        '(?s)Product still defines obligations and outcomes;\s+Engineering implements mechanisms and evidence, Studio expresses UI, and\s+`\.github` automates\.'
    )
    $decisionMatches = (
        ($actualDecisionHeadings -join "`n") -eq
            ($expectedDecisionHeadings -join "`n") -and
        ($actualDecisionIds -join "`n") -eq
            ($expectedDecisionIds -join "`n") -and
        ($actualSourceUrls -join "`n") -eq
            ($expectedSourceUrls -join "`n")
    )
    foreach ($pattern in $requiredDecisionPatterns) {
        if ($decisionRecord -notmatch $pattern) {
            $decisionMatches = $false
            break
        }
    }
    if (-not $decisionMatches) {
        Throw-ValidationError `
            -Code "RATIFICATION_DECISION_MISMATCH" `
            -Message "The Ratification decision record must preserve the exact catalog ranges, source PRs, evidence, non-goals, legal qualifier, handoffs, and Proposed metadata."
    }

    $textSummary = if ($SkipTrackedTextValidation) {
        "tracked-text validation skipped"
    }
    else {
        "$($textFiles.Count) tracked text files use LF endings"
    }
    Write-Host "Repository validation passed: $principleCount unique Ratified principles; immutable source $sourceCatalogCommit; semantic catalog SHA-256 $semanticCatalogHash; $textSummary."
}
finally {
    Pop-Location
}

exit 0
