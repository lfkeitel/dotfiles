#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up PowerShell'

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module oh-my-posh -Scope CurrentUser
Install-Module posh-git -AllowPrerelease -Scope CurrentUser -Force
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force

New-Directory "$HOME/.config/powershell"
Add-FileLink "$PSScriptRoot/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
