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
    -ExpectedMessage "Duplicate principle ID PROD-TEST-001"

exit 0
