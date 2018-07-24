#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)
if (!(Get-IsArch)) { return }

Write-Header 'Setting up Pacman'
Copy-Config -sudo "$PSScriptRoot/pacman.conf" "/etc/pacman.conf"
Copy-Config -sudo "$PSScriptRoot/mirrorlist" "/etc/pacman.d/mirrorlist"
