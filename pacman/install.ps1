#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)
if (!(Test-IsArch)) { return }

Write-Header 'Setting up Pacman'
Add-FileLink -Sudo "$PSScriptRoot/pacman.conf" "/etc/pacman.conf"
Add-FileLink -Sudo "$PSScriptRoot/reflector_sync.sh" "/opt/reflector_sync.sh"

Install-SystemPackage reflector

foreach ($d in (Get-ChildItem "$PSScriptRoot/hooks")) {
    Add-FileLink -Sudo $d.FullName "/etc/pacman.d/hooks/$($d.Name)"
}
