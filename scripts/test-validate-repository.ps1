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
        [string]$ExpectedMessage
    )

    $output = & pwsh -NoProfile -File $validator `
        -PrinciplesPath $Path `
        -SkipTrackedTextValidation 2>&1
    if ($LASTEXITCODE -eq 0) {
        throw "Expected the $Name fixture to fail validation."
    }
    $outputText = $output -join [Environment]::NewLine
    if ($outputText -notmatch [regex]::Escape($ExpectedMessage)) {
        throw "$Name fixture failed for an unexpected reason:`n$outputText"
    }

    Write-Host "$Name fixture failed as expected."
}

Write-Host $validOutput
Assert-InvalidFixture `
    -Name "missing-metadata" `
    -Path (Join-Path $root "scripts/fixtures/invalid-principles") `
    -ExpectedMessage "Verification"
Assert-InvalidFixture `
    -Name "duplicate-ID" `
    -Path (Join-Path $root "scripts/fixtures/duplicate-principles") `
    -ExpectedMessage "Duplicate principle ID PROD-BUS-999"
Assert-InvalidFixture `
    -Name "wrong-ID-namespace" `
    -Path (Join-Path $root "scripts/fixtures/invalid-namespace") `
    -ExpectedMessage "must use the PROD-COMP- namespace"
Assert-InvalidFixture `
    -Name "ambiguous-ratification" `
    -Path (Join-Path $root "scripts/fixtures/invalid-ratification") `
    -ExpectedMessage "owner-only Draft"
Assert-InvalidFixture `
    -Name "unresolvable-legacy-input" `
    -Path (Join-Path $root "scripts/fixtures/invalid-legacy-input") `
    -ExpectedMessage "resolvable backticked Studio legacy input IDs or none"
Assert-InvalidFixture `
    -Name "duplicate-metadata" `
    -Path (Join-Path $root "scripts/fixtures/duplicate-metadata") `
    -ExpectedMessage "must contain exactly one Status field"
Assert-InvalidFixture `
    -Name "unmapped-legacy-number" `
    -Path (Join-Path $root "scripts/fixtures/invalid-legacy-number") `
    -ExpectedMessage "does not resolve to a mapped"

exit 0
