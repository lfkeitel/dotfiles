#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' '..' Utils)

Write-Header 'Restoring Dconf Settings'
Get-Content -Path (Join-Path $PSScriptRoot dconf-export.txt) -Encoding utf8 | dconf load /
Remove-File $HOME/.config/autostart/key_swap.desktop

if ($IsLinux) {
    Add-FileLink -NoLink $PSScriptRoot/.Xmodmap $HOME/.Xmodmap
}
