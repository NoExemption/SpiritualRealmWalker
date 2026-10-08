$ErrorActionPreference = 'Stop'
$toolingRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$toolSources = @(Get-ChildItem -LiteralPath (Join-Path $toolingRoot 'Tools'), (Join-Path $toolingRoot 'Tests') -Recurse -File | Where-Object { $_.Extension -in @('.gd','.py','.cs','.ps1') })
foreach ($toolSource in $toolSources) {
    $toolText = Get-Content -LiteralPath $toolSource.FullName -Raw
    if ($toolText -match '["''][A-Za-z]:[/\\]' -or $toolText -match 'generated_images[/\\]') { throw "Machine/session path in tool: $($toolSource.FullName)" }
}
$cacheRootScripts = @(Get-ChildItem -LiteralPath (Join-Path $toolingRoot '.godot') -File | Where-Object { $_.Extension -in @('.gd','.py','.gdshader','.ps1') })
if ($cacheRootScripts.Count) { throw "Handwritten tool remains at cache root: $($cacheRootScripts.Name -join ', ')" }
$preset = Get-Content -LiteralPath (Join-Path $toolingRoot 'export_presets.cfg') -Raw
foreach ($excluded in @('Art/*','Tools/*','Tests/*')) { if (-not $preset.Contains($excluded)) { throw "Missing export exclusion: $excluded" } }
$readme = Get-Content -LiteralPath (Join-Path $toolingRoot 'README.md') -Raw
if ($readme.Contains('CHARACTER_SELECT_IDLE.md')) { throw 'README still lists superseded idle trial as current' }
Write-Output "Tooling checks passed: $($toolSources.Count) sources; no machine/session paths, no handwritten cache-root scripts, developer resources excluded."
