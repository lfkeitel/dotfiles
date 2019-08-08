#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Install fonts'
$ReloadFont = $false

$Library = "$HOME/.fonts"
if ($IsMacOS) {
    $Library = "$HOME/Library/Fonts"
}

if (!(Test-DirExists $Library)) {
    New-Directory $Library
}

function Install-Font ([string] $url, [string] $out) {
    if (!(Test-FileExists $out) -or $Force) {
        wget -q --show-progress -O $out $url
        return $IsLinux
    }
}

$Settings.fonts | ForEach-Object {
    $ReloadFont = (Install-Font $_.remote "$Library/$($_.name)") -or $ReloadFont
}

# Linux, reload font cache
if ($ReloadFont) {
    Write-Output 'Rescanning font caches'
    fc-cache -r
}
