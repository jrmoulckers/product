[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$requiredFiles = @(
    '.gitattributes'
    'AGENTS.md'
    'README.md'
    'principles/README.md'
)

$missingFiles = @($requiredFiles | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
if ($missingFiles.Count -gt 0) {
    throw "Missing required foundation files: $($missingFiles -join ', ')"
}

$lineEndings = & git ls-files --eol
if ($LASTEXITCODE -ne 0) {
    throw 'Unable to inspect tracked file line endings.'
}

$nonLfText = @(
    $lineEndings | Where-Object { $_ -match '(^|\s)[iw]/(crlf|mixed)(\s|$)' }
)
if ($nonLfText.Count -gt 0) {
    throw "Tracked text must use LF line endings:`n$($nonLfText -join "`n")"
}

& git diff --check HEAD --
if ($LASTEXITCODE -ne 0) {
    throw 'Git whitespace validation failed.'
}

Write-Host 'Repository validation passed: foundation files exist and tracked text uses LF.'
