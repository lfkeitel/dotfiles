#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)
if (!(Test-IsArch)) { return }

Write-Header 'Setting up Pacman'
Add-FileLink -Sudo "$PSScriptRoot/pacman.conf" "/etc/pacman.conf"
Remove-File -Sudo "/opt/reflector_sync.sh"
Add-FileLink -Sudo "$PSScriptRoot/reflector_sync.sh" "/usr/local/bin/reflector_sync"

Install-SystemPackage reflector

foreach ($d in (Get-ChildItem "$PSScriptRoot/hooks")) {
    Add-FileLink -Sudo $d.FullName "/etc/pacman.d/hooks/$($d.Name)"
}
