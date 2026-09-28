param(
    [string]$AssemblyPath = "$PSScriptRoot/../.godot/mono/temp/bin/Release/SpiritualRealmWalker.dll"
)
$ErrorActionPreference = 'Stop'
$assembly = [System.Reflection.Assembly]::LoadFrom((Resolve-Path $AssemblyPath))
$rules = $assembly.GetType('SpiritualRealmWalker.Progression.NightWandererProgression', $true)
$checked = 0
function Assert-Rule([string]$method, [int]$inputValue, [int]$expected) {
    $actual = $rules.GetMethod($method).Invoke($null, @($inputValue))
    if ($actual -ne $expected) { throw "$method($inputValue): expected $expected, got $actual" }
    $script:checked++
}

# 等级边界、封顶和异常值。
foreach ($case in @(@(-1,1,0), @(0,1,0), @(99,1,99), @(100,2,0),
    @(199,2,99), @(200,3,0), @(299,3,99), @(300,3,100), @(350,3,100))) {
    Assert-Rule 'Level' $case[0] $case[1]
    Assert-Rule 'LevelExperience' $case[0] $case[2]
}
# 四档试炼的每个临界值。
foreach ($case in @(@(0,4), @(99,4), @(100,3), @(139,3), @(140,2),
    @(169,2), @(170,1), @(199,1), @(200,0), @(300,0))) {
    Assert-Rule 'TrialTier' $case[0] $case[1]
}
# 典型路线与溢出。
Assert-Rule 'Level' (5 * 30 + 50) 3
Assert-Rule 'LevelExperience' (5 * 30 + 50) 0
Assert-Rule 'Level' (6 * 30) 2
Assert-Rule 'Clamp' (5 * 30 + 4 * 50) 300

# 所有本地化文件必须有效，双语卡牌和遗物的键保持一致。
foreach ($lang in @('zhs', 'eng')) {
    Get-ChildItem "$PSScriptRoot/../SpiritualRealmWalker/localization/$lang/*.json" | ForEach-Object {
        Get-Content $_.FullName -Raw | ConvertFrom-Json | Out-Null
    }
}
foreach ($table in @('cards', 'relics')) {
    $zh = Get-Content "$PSScriptRoot/../SpiritualRealmWalker/localization/zhs/$table.json" -Raw | ConvertFrom-Json -AsHashtable
    $en = Get-Content "$PSScriptRoot/../SpiritualRealmWalker/localization/eng/$table.json" -Raw | ConvertFrom-Json -AsHashtable
    if (Compare-Object @($zh.Keys) @($en.Keys)) { throw "$table localization keys differ" }
}
Write-Output "Passed $checked progression checks and bilingual localization validation."
