param(
    [string]$PrinciplesPath = "principles",
    [string]$ManifestPath = "principles/manifest.json",
    [switch]$Check
)

$ErrorActionPreference = "Stop"

$root = git rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0) {
    throw "Repository root could not be resolved."
}

Push-Location $root
try {
    $areasByFile = [ordered]@{
        "strategy.md"                  = "Strategy"
        "planning-and-delivery.md"     = "Planning and delivery"
        "business.md"                  = "Business"
        "discovery-and-experiments.md" = "Discovery and experiments"
        "metrics.md"                   = "Metrics"
        "compliance.md"                = "Compliance"
        "content-operations.md"        = "Content operations"
        "release-decisions.md"         = "Release decisions"
    }

    $principles = @()
    foreach ($fileName in $areasByFile.Keys) {
        $filePath = Join-Path $root (Join-Path $PrinciplesPath $fileName)
        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            throw "Registered principle file is missing: $fileName"
        }

        $content = (Get-Content -LiteralPath $filePath -Raw) -replace "`r`n", "`n"
        $blocks = [regex]::Matches(
            $content,
            '(?ms)^## (?<id>PROD-[A-Z]+-[0-9]{3}): (?<title>[^\n]+)$'
        )
        if ($blocks.Count -eq 0) {
            throw "No principles found in $fileName."
        }

        foreach ($block in $blocks) {
            $id = $block.Groups["id"].Value
            $body = [regex]::Match(
                $content,
                "(?ms)^## $([regex]::Escape($id)):[^\n]*\n(?<body>.*?)(?=^## |\z)"
            ).Groups["body"].Value
            $status = [regex]::Match(
                $body,
                '(?m)^- \*\*Status:\*\*[ \t]+(?<value>.+)$'
            ).Groups["value"].Value.Trim()

            $principles += [ordered]@{
                id     = $id
                title  = $block.Groups["title"].Value.Trim()
                area   = $areasByFile[$fileName]
                file   = "$PrinciplesPath/$fileName"
                status = $status
            }
        }
    }

    $manifest = [ordered]@{
        '$comment'   = "Generated from principles/*.md by scripts/build-manifest.ps1. Do not hand-edit; scripts/validate-repository.ps1 regenerates and compares this file."
        authority    = "product"
        repository   = "jrmoulckers/product"
        owns         = "Product obligations and outcomes"
        ratification = [ordered]@{
            state               = "effective"
            date                = "2026-08-09"
            owner               = "jrmoulckers"
            pullRequest         = "https://github.com/jrmoulckers/product/pull/5"
            mergeCommit         = "3a752c11856515a74eb204675d5d5198cac1e48e"
            decisionRecord      = "docs/architecture/0001-ratify-product-principles.md"
            ratificationRecord  = "docs/ratification/2026-08-09-product-principles.md"
            sourceCatalogCommit = "b0b2ef66094bbc5abf19cd4ae0ac85b05f12ddb5"
        }
        count        = $principles.Count
        principles   = $principles
    }

    $expected = (($manifest | ConvertTo-Json -Depth 6) -replace "`r`n", "`n").TrimEnd("`n") + "`n"
    $resolvedManifestPath = Join-Path $root $ManifestPath

    if ($Check) {
        if (-not (Test-Path -LiteralPath $resolvedManifestPath -PathType Leaf)) {
            throw "[MANIFEST_MISSING] $ManifestPath does not exist; run ./scripts/build-manifest.ps1."
        }
        $actual = ((Get-Content -LiteralPath $resolvedManifestPath -Raw) -replace "`r`n", "`n").TrimEnd("`n") + "`n"
        if ($actual -ne $expected) {
            throw "[MANIFEST_DRIFT] $ManifestPath does not match the principle catalog; run ./scripts/build-manifest.ps1."
        }
        Write-Host "Manifest matches the catalog: $($principles.Count) principles."
    }
    else {
        [IO.File]::WriteAllText(
            $resolvedManifestPath,
            $expected,
            (New-Object Text.UTF8Encoding $false)
        )
        Write-Host "Wrote $ManifestPath with $($principles.Count) principles."
    }
}
finally {
    Pop-Location
}
