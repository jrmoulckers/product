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
        [string]$ExpectedErrorId
    )

    $output = & pwsh -NoProfile -File $validator `
        -PrinciplesPath $Path `
        -SkipTrackedTextValidation 2>&1
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
Assert-HarnessRejectsWrongErrorId

exit 0
