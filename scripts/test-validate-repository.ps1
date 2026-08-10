$ErrorActionPreference = "Stop"

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw "Repository root could not be resolved."
}

$validator = Join-Path $root "scripts/validate-repository.ps1"
$validOutput = & pwsh -NoProfile -File $validator 2>&1
if ($LASTEXITCODE -ne 0) {
    throw "Expected repository validation to pass:`n$($validOutput -join [Environment]::NewLine)"
}

function Assert-InvalidFixture {
    param(
        [string]$Name,
        [string]$Path,
        [string]$ExpectedErrorId,
        [string]$DecisionRecordPath,
        [string[]]$ExtraArguments = @()
    )

    $arguments = @(
        "-NoProfile",
        "-File",
        $validator,
        "-PrinciplesPath",
        $Path,
        "-SkipTrackedTextValidation"
    )
    if ($DecisionRecordPath) {
        $arguments += @("-DecisionRecordPath", $DecisionRecordPath)
    }
    $arguments += $ExtraArguments
    $output = & pwsh @arguments 2>&1
    if ($LASTEXITCODE -eq 0) {
        throw "Expected the $Name fixture to fail validation."
    }
    $ansiEscapePattern = "$([char]27)\[[0-?]*[ -/]*[@-~]"
    $outputText = ($output -join [Environment]::NewLine) -replace $ansiEscapePattern, ""
    $expectedTag = "[$ExpectedErrorId]"
    $tagCount = [regex]::Matches(
        $outputText,
        [regex]::Escape($expectedTag)
    ).Count
    if ($tagCount -ne 1) {
        throw "$Name fixture failed for an unexpected reason:`n$outputText"
    }

    Write-Host "$Name fixture failed as expected."
}

function Set-FixtureContent {
    param(
        [string]$Path,
        [string]$Content
    )

    Set-Content -LiteralPath $Path -Value $Content -NoNewline
}

function Assert-MutatedCatalogInvalid {
    param(
        [string]$Name,
        [string]$ExpectedErrorId,
        [scriptblock]$Mutation
    )

    $fixtureRoot = Join-Path $testTempRoot $Name
    $fixturePrinciples = Join-Path $fixtureRoot "principles"
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
    Copy-Item -LiteralPath (Join-Path $root "principles") `
        -Destination $fixturePrinciples `
        -Recurse
    & $Mutation $fixturePrinciples
    Assert-InvalidFixture `
        -Name $Name `
        -Path $fixturePrinciples `
        -ExpectedErrorId $ExpectedErrorId
}

function Assert-MutatedDecisionInvalid {
    param(
        [string]$Name,
        [string]$ExpectedErrorId,
        [scriptblock]$Mutation
    )

    $fixtureRoot = Join-Path $testTempRoot $Name
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null
    $fixtureDecision = Join-Path $fixtureRoot "0001-ratify-product-principles.md"
    Copy-Item `
        -LiteralPath (Join-Path $root "docs/architecture/0001-ratify-product-principles.md") `
        -Destination $fixtureDecision
    & $Mutation $fixtureDecision
    Assert-InvalidFixture `
        -Name $Name `
        -Path (Join-Path $root "principles") `
        -ExpectedErrorId $ExpectedErrorId `
        -DecisionRecordPath $fixtureDecision
}

function Assert-MutatedConsumptionInvalid {
    param(
        [string]$Name,
        [string]$ExpectedErrorId,
        [ValidateSet("Manifest", "RatificationRecord", "Consuming", "Templates")]
        [string]$Surface,
        [scriptblock]$Mutation
    )

    $fixtureRoot = Join-Path $testTempRoot $Name
    New-Item -ItemType Directory -Path $fixtureRoot | Out-Null

    switch ($Surface) {
        "Manifest" {
            $fixture = Join-Path $fixtureRoot "manifest.json"
            Copy-Item -LiteralPath (Join-Path $root "principles/manifest.json") -Destination $fixture
            $switchName = "-ManifestPath"
        }
        "RatificationRecord" {
            $fixture = Join-Path $fixtureRoot "ratification.md"
            Copy-Item `
                -LiteralPath (Join-Path $root "docs/ratification/2026-08-09-product-principles.md") `
                -Destination $fixture
            $switchName = "-RatificationRecordPath"
        }
        "Consuming" {
            $fixture = Join-Path $fixtureRoot "CONSUMING.md"
            Copy-Item -LiteralPath (Join-Path $root "CONSUMING.md") -Destination $fixture
            $switchName = "-ConsumingPath"
        }
        "Templates" {
            $fixture = Join-Path $fixtureRoot "templates"
            Copy-Item -LiteralPath (Join-Path $root "templates") -Destination $fixture -Recurse
            $switchName = "-TemplatesPath"
        }
    }

    & $Mutation $fixture
    Assert-InvalidFixture `
        -Name $Name `
        -Path (Join-Path $root "principles") `
        -ExpectedErrorId $ExpectedErrorId `
        -ExtraArguments @($switchName, $fixture)
}

function Assert-HarnessRejectsWrongErrorId {
    $expectedHarnessMessage = "wrong-error-ID fixture failed for an unexpected reason"
    try {
        Assert-InvalidFixture `
            -Name "wrong-error-ID" `
            -Path (Join-Path $root "scripts/fixtures/invalid-ratification") `
            -ExpectedErrorId "PRINCIPLE_DUPLICATE_ID"
    }
    catch {
        if ($_.Exception.Message -notmatch [regex]::Escape($expectedHarnessMessage)) {
            throw
        }
        Write-Host "Wrong error ID was rejected as expected."
        return
    }

    throw "Expected the harness to reject an unrelated error ID."
}

$testTempRoot = Join-Path (
    [IO.Path]::GetTempPath()
) ("product-repository-validation-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $testTempRoot | Out-Null

try {
    Write-Host $validOutput
    Assert-InvalidFixture `
        -Name "missing-metadata" `
        -Path (Join-Path $root "scripts/fixtures/invalid-principles") `
        -ExpectedErrorId "PRINCIPLE_MISSING_METADATA"
    Assert-InvalidFixture `
        -Name "duplicate-ID" `
        -Path (Join-Path $root "scripts/fixtures/duplicate-principles") `
        -ExpectedErrorId "PRINCIPLE_DUPLICATE_ID"
    Assert-InvalidFixture `
        -Name "wrong-ID-namespace" `
        -Path (Join-Path $root "scripts/fixtures/invalid-namespace") `
        -ExpectedErrorId "PRINCIPLE_ID_NAMESPACE"
    Assert-InvalidFixture `
        -Name "ambiguous-ratification" `
        -Path (Join-Path $root "scripts/fixtures/invalid-ratification") `
        -ExpectedErrorId "PRINCIPLE_RATIFICATION"
    Assert-InvalidFixture `
        -Name "unresolvable-legacy-input" `
        -Path (Join-Path $root "scripts/fixtures/invalid-legacy-input") `
        -ExpectedErrorId "PRINCIPLE_LEGACY_FORMAT"
    Assert-InvalidFixture `
        -Name "duplicate-metadata" `
        -Path (Join-Path $root "scripts/fixtures/duplicate-metadata") `
        -ExpectedErrorId "PRINCIPLE_DUPLICATE_METADATA"
    Assert-InvalidFixture `
        -Name "unmapped-legacy-number" `
        -Path (Join-Path $root "scripts/fixtures/invalid-legacy-number") `
        -ExpectedErrorId "PRINCIPLE_LEGACY_UNMAPPED"

    Assert-MutatedCatalogInvalid `
        -Name "mixed-status" `
        -ExpectedErrorId "PRINCIPLE_STATUS" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = [regex]::Replace(
                $content,
                '(?m)^- \*\*Status:\*\* Ratified$',
                '- **Status:** Draft',
                1
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "unauthorized-status" `
        -ExpectedErrorId "PRINCIPLE_STATUS" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = [regex]::Replace(
                $content,
                '(?m)^- \*\*Status:\*\* Ratified$',
                '- **Status:** Approved',
                1
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "catalog-deletion" `
        -ExpectedErrorId "PRINCIPLE_CATALOG_IDS" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = [regex]::Replace(
                $content,
                '(?ms)^## PROD-STRAT-003:.*\z',
                ""
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "catalog-renumbering" `
        -ExpectedErrorId "PRINCIPLE_CATALOG_IDS" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace("PROD-STRAT-003:", "PROD-STRAT-004:")
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "catalog-preamble-drift" `
        -ExpectedErrorId "PRINCIPLE_SEMANTIC_DRIFT" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "Draft Product obligations for choosing direction",
                "Product obligations for choosing direction"
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "principle-wording-drift" `
        -ExpectedErrorId "PRINCIPLE_SEMANTIC_DRIFT" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "Choose strategies that create durable user value",
                "Choose strategies that create immediate user value"
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedCatalogInvalid `
        -Name "legacy-input-drift" `
        -ExpectedErrorId "PRINCIPLE_SEMANTIC_DRIFT" `
        -Mutation {
            param($principles)
            $path = Join-Path $principles "strategy.md"
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "studio-legacy:business:6",
                "studio-legacy:business:5"
            )
            Set-FixtureContent -Path $path -Content $content
        }

    Assert-InvalidFixture `
        -Name "missing-decision-record" `
        -Path (Join-Path $root "principles") `
        -ExpectedErrorId "RATIFICATION_DECISION_MISSING" `
        -DecisionRecordPath (Join-Path $testTempRoot "missing-decision.md")
    Assert-MutatedDecisionInvalid `
        -Name "mismatched-decision-record" `
        -ExpectedErrorId "RATIFICATION_DECISION_MISMATCH" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "https://github.com/jrmoulckers/product/pull/4",
                "https://github.com/jrmoulckers/product/pull/5"
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedDecisionInvalid `
        -Name "non-owner-approval" `
        -ExpectedErrorId "RATIFICATION_APPROVAL_AUTHORITY" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "If and only if the repository owner merges",
                "If and only if any maintainer merges"
            )
            Set-FixtureContent -Path $path -Content $content
        }

    Assert-MutatedConsumptionInvalid `
        -Name "manifest-drift" `
        -ExpectedErrorId "MANIFEST_DRIFT" `
        -Surface "Manifest" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace("PROD-STRAT-001", "PROD-STRAT-999")
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "ratification-record-missing" `
        -ExpectedErrorId "RATIFICATION_RECORD_MISSING" `
        -Surface "RatificationRecord" `
        -Mutation {
            param($path)
            Remove-Item -LiteralPath $path -Force
        }
    Assert-MutatedConsumptionInvalid `
        -Name "ratification-record-wrong-merge-commit" `
        -ExpectedErrorId "RATIFICATION_RECORD_MISMATCH" `
        -Surface "RatificationRecord" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace(
                "3a752c11856515a74eb204675d5d5198cac1e48e",
                "0000000000000000000000000000000000000000"
            )
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "ratification-record-dropped-legal-qualifier" `
        -ExpectedErrorId "RATIFICATION_RECORD_MISMATCH" `
        -Surface "RatificationRecord" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace("not legal advice", "legal advice")
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "consuming-guide-missing" `
        -ExpectedErrorId "CONSUMING_GUIDE_MISSING" `
        -Surface "Consuming" `
        -Mutation {
            param($path)
            Remove-Item -LiteralPath $path -Force
        }
    Assert-MutatedConsumptionInvalid `
        -Name "consuming-guide-allows-branch-citation" `
        -ExpectedErrorId "CONSUMING_GUIDE_MISMATCH" `
        -Surface "Consuming" `
        -Mutation {
            param($path)
            $content = Get-Content -LiteralPath $path -Raw
            $content = $content.Replace("Never cite a branch", "Cite a branch")
            Set-FixtureContent -Path $path -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "template-removed" `
        -ExpectedErrorId "TEMPLATE_SET" `
        -Surface "Templates" `
        -Mutation {
            param($path)
            Remove-Item -LiteralPath (Join-Path $path "metric-definition.md") -Force
        }
    Assert-MutatedConsumptionInvalid `
        -Name "template-unlisted" `
        -ExpectedErrorId "TEMPLATE_INDEX_MISMATCH" `
        -Surface "Templates" `
        -Mutation {
            param($path)
            $indexPath = Join-Path $path "README.md"
            $content = Get-Content -LiteralPath $indexPath -Raw
            $content = $content.Replace("(go-no-go-record.md)", "(go-no-go.md)")
            Set-FixtureContent -Path $indexPath -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "template-uncited" `
        -ExpectedErrorId "TEMPLATE_CITATION_MISSING" `
        -Surface "Templates" `
        -Mutation {
            param($path)
            $templatePath = Join-Path $path "metric-definition.md"
            $content = Get-Content -LiteralPath $templatePath -Raw
            $content = [regex]::Replace($content, 'PROD-[A-Z]+-[0-9]{3}', "a Product obligation")
            Set-FixtureContent -Path $templatePath -Content $content
        }
    Assert-MutatedConsumptionInvalid `
        -Name "template-unresolvable-citation" `
        -ExpectedErrorId "TEMPLATE_CITATION_UNRESOLVABLE" `
        -Surface "Templates" `
        -Mutation {
            param($path)
            $templatePath = Join-Path $path "go-no-go-record.md"
            $content = Get-Content -LiteralPath $templatePath -Raw
            $content = $content.Replace("PROD-REL-001", "PROD-REL-999")
            Set-FixtureContent -Path $templatePath -Content $content
        }

    Assert-HarnessRejectsWrongErrorId
}
finally {
    Remove-Item -LiteralPath $testTempRoot -Recurse -Force
}

exit 0
