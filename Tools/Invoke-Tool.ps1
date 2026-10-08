[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Script,
    [string]$GodotExe,
    [string]$PythonExe,
    [string]$GameDir,
    [string]$ModPack,
    [string[]]$ToolArguments = @(),
    [switch]$Gpu,
    [switch]$CheckOnly
)
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$settingsPath = Join-Path $projectRoot 'tool-settings.local.json'
$settings = if (Test-Path -LiteralPath $settingsPath) { Get-Content -LiteralPath $settingsPath -Raw | ConvertFrom-Json } else { $null }
function Resolve-Setting([string]$explicitValue, [string]$environmentName, [string]$key, [string]$fallback = '') {
    if ($explicitValue) { return $explicitValue }
    $environmentValue = [Environment]::GetEnvironmentVariable($environmentName)
    if ($environmentValue) { return $environmentValue }
    if ($settings -and $settings.PSObject.Properties[$key] -and $settings.$key) { return [string]$settings.$key }
    return $fallback
}
$GameDir = Resolve-Setting $GameDir 'STS2_GAME_DIR' 'GameDir'
$GodotExe = Resolve-Setting $GodotExe 'GODOT_EXE' 'GodotExe' 'godot'
$PythonExe = Resolve-Setting $PythonExe 'PYTHON_EXE' 'PythonExe' 'python'
$ModPack = Resolve-Setting $ModPack 'SRW_MOD_PACK' 'ModPack'
$scriptPath = [IO.Path]::GetFullPath((Join-Path $projectRoot $Script))
if (-not ($scriptPath.StartsWith((Join-Path $projectRoot 'Tools') + '\', [StringComparison]::OrdinalIgnoreCase) -or $scriptPath.StartsWith((Join-Path $projectRoot 'Tests') + '\', [StringComparison]::OrdinalIgnoreCase))) { throw 'Script must be inside Tools or Tests' }
if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) { throw "Tool not found: $scriptPath" }
switch ([IO.Path]::GetExtension($scriptPath)) {
    '.py' {
        if ($CheckOnly) { & $PythonExe -c 'import ast,sys; ast.parse(open(sys.argv[1],encoding="utf-8-sig").read()); print("PYTHON_SYNTAX_OK")' $scriptPath }
        else { & $PythonExe $scriptPath @ToolArguments }
    }
    '.gd' {
        $logDir = Join-Path $projectRoot '.godot/tool-logs'
        [IO.Directory]::CreateDirectory($logDir) | Out-Null
        $relative = [IO.Path]::GetRelativePath($projectRoot, $scriptPath).Replace('\', '/')
        $godotArgs = @('--path', $projectRoot, '--script', "res://$relative", '--log-file', (Join-Path $logDir ([IO.Path]::GetFileNameWithoutExtension($scriptPath) + '.log')))
        if (-not $Gpu) { $godotArgs += '--headless' }
        if ($CheckOnly) { $godotArgs += '--check-only' }
        $userArgs = @()
        if ($GameDir) { $userArgs += @('--game-dir', $GameDir) }
        if ($ModPack) { $userArgs += @('--mod-pack', $ModPack) }
        $userArgs += $ToolArguments
        if ($userArgs.Count -gt 0) { $godotArgs += '--'; $godotArgs += $userArgs }
        & $GodotExe @godotArgs
    }
    '.csproj' {
        if ($CheckOnly) { & dotnet build $scriptPath --no-restore }
        else { & dotnet run --project $scriptPath -- @ToolArguments }
    }
    default { throw 'Supported tools: .gd, .py and .csproj' }
}
if ($LASTEXITCODE -ne 0) { throw "Tool failed with exit code $LASTEXITCODE" }
