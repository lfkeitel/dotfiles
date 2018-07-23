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

Add-FileLink "$PSScriptRoot/.calcurse/conf" "$HOME/.calcurse/conf"
Add-FileLink "$PSScriptRoot/.calcurse/keys" "$HOME/.calcurse/keys"

systemctl --user daemon-reload

if (Get-IsArch) {
    systemctl --user enable pacupdate.timer
    systemctl --user enable udiskie.service
}
