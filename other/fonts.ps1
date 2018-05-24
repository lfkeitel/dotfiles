#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Install Inconsolata font'
$ReloadFont = $false

$Library = "$HOME/.fonts"
if ($IsMacOS) {
    $Library = "$HOME/Library/Fonts"
}

if (!(Test-DirExists $Library)) {
    New-Directory $Library
}

function Install-Font ([string] $url, [string] $out) {
    if (!(Test-FileExists $out)) {
        wget -q --show-progress -O $out $url
        if ($IsLinux) { $ReloadFont = $true }
    }
}

$Settings.fonts | ForEach-Object {
    Install-Font $_.remote "$Library/$($_.name)"
}

# Linux, reload font cache
if ($ReloadFont) {
    fc-cache -f
}
