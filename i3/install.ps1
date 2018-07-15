#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up i3'
Write-ColoredLine 'Remember to install i3 and any relevent packages' Magenta

Add-FileLink "$PSScriptRoot/.scripts" "$HOME/.scripts"
Add-FileLink "$PSScriptRoot/.profile" "$HOME/.profile"

$dir = Get-ChildItem "$PSScriptRoot/.config" | ?{$_.PSISContainer}

foreach ($d in $dir) {
    Add-FileLink $d.FullName "$HOME/.config/$($d.Name)"
}

systemctl --user daemon-reload
systemctl --user enable pacupdate.timer
systemctl --user enable udiskie.service
