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

$fixturePath = Join-Path $root "scripts/fixtures/invalid-principles"
$invalidOutput = & pwsh -NoProfile -File $validator `
    -PrinciplesPath $fixturePath `
    -SkipTrackedTextValidation 2>&1
if ($LASTEXITCODE -eq 0) {
    throw "Expected the missing-metadata fixture to fail validation."
}
$invalidText = $invalidOutput -join [Environment]::NewLine
if ($invalidText -notmatch "Verification") {
    throw "Negative fixture failed for an unexpected reason:`n$($invalidOutput -join [Environment]::NewLine)"
}

Write-Host $validOutput
Write-Host "Negative metadata fixture failed as expected."

exit 0
