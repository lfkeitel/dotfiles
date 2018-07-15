#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up i3'
Write-ColoredLine 'Remember to install i3 and any relevent packages' Magenta

Add-FileLink "$PSScriptRoot/.scripts" "$HOME/.scripts"
Add-FileLink "$PSScriptRoot/.profile" "$HOME/.profile"

Add-FileLink "$PSScriptRoot/.config/i3" "$HOME/.config/i3"
Add-FileLink "$PSScriptRoot/.config/i3blocks" "$HOME/.config/i3blocks"
Add-FileLink "$PSScriptRoot/.config/dunst" "$HOME/.config/dunst"
Add-FileLink "$PSScriptRoot/.config/rofi" "$HOME/.config/rofi"
Add-FileLink "$PSScriptRoot/.config/systemd" "$HOME/.config/systemd"

systemctl --user daemon-reload
systemctl --user enable pacupdate.timer
systemctl --user enable udiskie.service
