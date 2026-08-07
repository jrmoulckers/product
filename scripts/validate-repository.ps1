$ErrorActionPreference = "Stop"

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw "Repository root could not be resolved."
}

Push-Location $root
try {
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

    Write-Host "Repository validation passed: $($textFiles.Count) tracked text files use LF endings."
}
finally {
    Pop-Location
}

exit 0
