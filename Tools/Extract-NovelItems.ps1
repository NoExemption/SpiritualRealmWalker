[CmdletBinding()]
param(
    [string]$InputPath = (Join-Path $PSScriptRoot '..\灵境行者.txt'),
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\ITEMS.md')
)

$ErrorActionPreference = 'Stop'

$resolvedInput = (Resolve-Path -LiteralPath $InputPath).Path
$resolvedOutput = [System.IO.Path]::GetFullPath($OutputPath)
$sourceLines = [System.IO.File]::ReadAllLines($resolvedInput)

$namePattern = '^\s*【名称[：:](?<name>.*?)】\s*$'
$fieldPattern = '^\s*【(?<field>[^：:】]+)[：:](?<value>.*)】\s*$'
$entries = [System.Collections.Generic.List[object]]::new()
$current = $null

function Complete-CurrentEntry {
    if ($null -eq $script:current) {
        return
    }

    if ($script:current.Lines.Count -gt 0) {
        $script:entries.Add([pscustomobject]@{
            Name      = $script:current.Name
            StartLine = $script:current.StartLine
            Lines     = @($script:current.Lines)
        })
    }

    $script:current = $null
}

for ($index = 0; $index -lt $sourceLines.Length; $index++) {
    $line = $sourceLines[$index]
    $nameMatch = [regex]::Match($line, $namePattern)

    if ($nameMatch.Success) {
        Complete-CurrentEntry
        $current = [pscustomobject]@{
            Name      = $nameMatch.Groups['name'].Value.Trim()
            StartLine = $index + 1
            Lines     = [System.Collections.Generic.List[string]]::new()
        }
        $current.Lines.Add($line.Trim())
        continue
    }

    if ($null -eq $current) {
        continue
    }

    $fieldMatch = [regex]::Match($line, $fieldPattern)
    if ($fieldMatch.Success) {
        $current.Lines.Add($line.Trim())
        continue
    }

    if ([string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    Complete-CurrentEntry
}

Complete-CurrentEntry

# 每一次属性展示都可能代表不同道具、改造前后状态或信息揭示阶段。
# 因此不按名称或内容去重，严格保留原文中的全部出现次数和先后顺序。
$selectedEntries = $entries | Sort-Object -Property StartLine

$outputLines = [System.Collections.Generic.List[string]]::new()
$number = 1
foreach ($entry in $selectedEntries) {
    $outputLines.Add(('## {0:D3}. {1}' -f $number, $entry.Name))
    $outputLines.Add(('> 原文第 {0} 行' -f $entry.StartLine))
    $outputLines.Add('')
    foreach ($attributeLine in $entry.Lines) {
        $outputLines.Add($attributeLine)
    }
    $outputLines.Add('')
    $number++
}

if ($outputLines.Count -gt 0 -and $outputLines[$outputLines.Count - 1] -eq '') {
    $outputLines.RemoveAt($outputLines.Count - 1)
}

$outputDirectory = [System.IO.Path]::GetDirectoryName($resolvedOutput)
if (-not [System.IO.Directory]::Exists($outputDirectory)) {
    [System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
}

$utf8WithoutBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllLines($resolvedOutput, $outputLines, $utf8WithoutBom)

Write-Output ("Extracted {0} item entries; all formatted occurrences were preserved." -f
    $selectedEntries.Count)
Write-Output ("Output: {0}" -f $resolvedOutput)
