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
    $expectedCatalogByFile = [ordered]@{
        "business.md" = [ordered]@{
            "PROD-BUS-001" = "b26288f8c26db8fc2cb6055f1e48e22f57f298ac624367c5551a54837ea25d24"
            "PROD-BUS-002" = "5b435b1e7c3982faac9479d58af303d2147918fb9c7a0a11035aeffa3031e600"
            "PROD-BUS-003" = "b30505830567c4af5bdf3762f111208215cd9ad821eac25d359dbb1d802479da"
        }
        "compliance.md" = [ordered]@{
            "PROD-COMP-001" = "9108c7ec4d04b92b4690b6bd257a8ac990a42708e95e16189cf376e32207222f"
            "PROD-COMP-002" = "406da885e70b8b23f61ba80d7d74c6a6825e7814a35d04a4d274ffd83ec3f5cc"
            "PROD-COMP-003" = "40982691374c890ca4216d2dde0827803bd3b23b1f3349dabaa98c23180ec672"
            "PROD-COMP-004" = "4d2e3b69fb2101a59fc8d8c9a894dc6352d689be045f69b425e7f2a9806a9442"
            "PROD-COMP-005" = "9c15202c4df9f5f135b99399841457c62315af1898fd8a51ec60892e09cb0ed9"
            "PROD-COMP-006" = "a53f1ad98409d91ed0c29713171666b420111f0b94ed5541ef95d12b6877c789"
            "PROD-COMP-007" = "cb35fd354a684a91219938ba0c915a2ff3b666deab84d883c7aa3d0feac4924f"
            "PROD-COMP-008" = "e5d38c1052f6e829567e0decef5f5d667ffd7445c01dbf16ab30ee3b1af4bb90"
            "PROD-COMP-009" = "45b8299724d3a848609d483bb1f867664066822e1a3bcd53dbf295ef09f2ddde"
        }
        "content-operations.md" = [ordered]@{
            "PROD-CONTENT-001" = "381603534f4d643f47904b83c62eb5299281cfac3c0b43780c1c4dffe991cda2"
            "PROD-CONTENT-002" = "679a10a877d87bd8d1d769e28d2606dfb7a709a3b889fd19d11f4e62f9021dec"
            "PROD-CONTENT-003" = "5fd0f84254269dcc2be1770e040b095a91c368cf6790329b6b4572a3fddf78f5"
            "PROD-CONTENT-004" = "aa6281405df097b0e777b012f57639b692b39281c07170d9e6c0a2082467e9a2"
            "PROD-CONTENT-005" = "37b89a2549abed4f90ce475c6ca97c7bd1dfb662236a7d8223164b672e5c0740"
            "PROD-CONTENT-006" = "63a0de0cdf197024cb00850aa49512cde25e2d658672a87b3b1819b955e4ceb8"
            "PROD-CONTENT-007" = "33289aa70cc75de787ce88a6a43ef29a135770a42300c3778ff0ad8a9035e112"
            "PROD-CONTENT-008" = "bf9493a5003f6d7d994839fd319f7e88f60b21e1b870a28fb662b21148aa7b73"
            "PROD-CONTENT-009" = "9419a0727489140353bd5e0dd50a1fa33110b4c090de2c529f78f58b0985f349"
        }
        "discovery-and-experiments.md" = [ordered]@{
            "PROD-DISC-001" = "5726ab890ed578a316b62f264f4f6bd927ebf34bce134dd9c1c98637dcde69a9"
            "PROD-DISC-002" = "bf3b1bdba64009b84a6d0cb66f52d73ea67571e1903259036b0ac726596c8cf5"
            "PROD-DISC-003" = "2073aaef12b65957814c252222cb1c5cf5799be8d579e795ab1b9522dbef70cf"
            "PROD-DISC-004" = "81e27ed632e2d44c50b260519fc23fcc5c3f5036e1b38aa85d6591977f4373aa"
        }
        "metrics.md" = [ordered]@{
            "PROD-MET-001" = "66380738e45fd75f87b10bc8f30282a897800aa972398c63abce87157905e448"
            "PROD-MET-002" = "8969066eb2ccf5333f6029c52ff8dc0b814930b6c910498139530973563ee58a"
            "PROD-MET-003" = "a9dfefe46e6933f1925f99cbcb533003a054ceea5b555bdb111d35297604e148"
        }
        "planning-and-delivery.md" = [ordered]@{
            "PROD-PLAN-001" = "e7c2d03e3903911b8188d045dbf0e748176bf5826d5a0bb04dada4afc2466453"
            "PROD-PLAN-002" = "91f6dfd7e58800f1d91f950ce1db2c1373938295f56367667b3548cf16d00016"
            "PROD-PLAN-003" = "f9803e0043d6e0af296e76ab0719ea2adf401737fb04192cbd9054066690f6db"
            "PROD-PLAN-004" = "64e48d1b98fb1472cb962d930cff2b0ba2e201ece859802e423f1acff3393ece"
            "PROD-PLAN-005" = "bb46af05a229a521b6c1418c440635773c7e0d4665cf0a4a3c3e5221152b6ebb"
        }
        "release-decisions.md" = [ordered]@{
            "PROD-REL-001" = "2821624a5d25e587554bc16455bdf39c994b46a4708267c0c729ff809cc56813"
            "PROD-REL-002" = "555f329f3cb7ac6fbbf863e3d56c71bb466ac8e9b435af77f63c24ca6460057a"
            "PROD-REL-003" = "53766d78be1333e50be309611a0004408711e5454381a888913943f5e8b6a452"
            "PROD-REL-004" = "f9bed359d068ba7f8fc56a0297eeff5af6e98c79de0232c67a784b592fd1afb0"
        }
        "strategy.md" = [ordered]@{
            "PROD-STRAT-001" = "38749a2d04b133f94cb4d4849974122fcdb8a193151fc9d05863ba709a3ae9fe"
            "PROD-STRAT-002" = "45ea9f88d0aeb771787e3d9c270a4d394900b874938edb744a9a4011e29b4adf"
            "PROD-STRAT-003" = "73e82ab19757df086645fbdb2792e0b5bd7b6a5d86285ccc6897419e13c079c4"
        }
    }
    $expectedCatalogSemanticHash = "e906730c0648b240d2dfe0062da07ac9114cf70fb5951902b21a3b80d177d16d"
    $expectedFileSemanticHashes = @{
        "business.md"                  = "84dcd59a8d9739a474970239f81709d2f73de1735444d042c4599083a2d65f8a"
        "compliance.md"                = "83dbd249cf7d4bec06cabc0ed943ffe02492446d3808e7adcd580318bb0b5b8e"
        "content-operations.md"        = "b3f090a6f46b39d4a19cc816b6f7324738a631051e914283d321e080ceeabf02"
        "discovery-and-experiments.md" = "131e52d6d3ed1715616483f262e7403d0c5f7b836ba872f070824a6816d0aa77"
        "metrics.md"                   = "3a20f62daf877abf000880ff014ea1d8d26152f5da3851dec8c4496662a12edc"
        "planning-and-delivery.md"     = "18c1f3d82e23a55153a9fee5d27d3cbe510e522ac00e9da978b4c93092d0a5e2"
        "release-decisions.md"         = "221f25f4af81f81224be7a7ebb7efe8e35b70c656b07e06541487d33da47d8e4"
        "strategy.md"                  = "089ae0b748feadfec7842a60bce91da447119fc942a5ddb53a16b5320563d4d9"
    }
    $expectedDecisionRecordHash = "29f43cbde97859e521cc095d127e0645408108ca63f40ac7d440abe60f378591"
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

    $decisionRecord = Get-Content -LiteralPath $resolvedDecisionRecordPath -Raw
    $ownerAuthorityPattern = '(?ms)^## Ratification\s+This record contains no approval\. If and only if the repository owner merges\s+the pull request that introduces it, that merge is the explicit Ratification\s+act and makes this decision effective\. Reviews, agent-authored commits, green\s+validation, or approval or merge by anyone else do not ratify the catalog\.\s*$'
    if ($decisionRecord -notmatch $ownerAuthorityPattern) {
        Throw-ValidationError `
            -Code "RATIFICATION_APPROVAL_AUTHORITY" `
            -Message "The decision record must make repository-owner merge the sole effective approval and must not imply prior, ambiguous, or non-owner approval."
    }
    if ((Get-NormalizedSha256 -Text $decisionRecord) -ne $expectedDecisionRecordHash) {
        Throw-ValidationError `
            -Code "RATIFICATION_DECISION_MISMATCH" `
            -Message "The Ratification decision record must preserve the exact catalog ranges, source PRs, evidence, non-goals, and owner-merge terms."
    }

    $textSummary = if ($SkipTrackedTextValidation) {
        "tracked-text validation skipped"
    }
    else {
        "$($textFiles.Count) tracked text files use LF endings"
    }
    Write-Host "Repository validation passed: $principleCount unique Ratified principles; semantic catalog SHA-256 $semanticCatalogHash; $textSummary."
}
finally {
    Pop-Location
}

exit 0
