#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Generic Configs'

# Generic scripts, utilities, and profile
Add-FileLink "$PSScriptRoot/scripts" "$HOME/.scripts"
Add-FileLink "$PSScriptRoot/.profile" "$HOME/.profile"

# Link simply .config directories
$dir = Get-ChildItem "$PSScriptRoot/config" | ?{$_.PSISContainer}

foreach ($d in $dir) {
    Add-FileLink $d.FullName "$HOME/.config/$($d.Name)"
}

& "$PSScriptRoot/calcurse/install.ps1"

# Reload systemd units from config linking
if (!($IsMacOS)) {
    systemctl --user daemon-reload
    systemctl --user enable newsboat.timer

    if (Get-IsArch) {
        systemctl --user enable pacupdate.timer
    }
}

& "$PSScriptRoot/home/install.ps1"