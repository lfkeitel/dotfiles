#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Minicom'
Add-FileLink "$PSScriptRoot/.minirc.dfl" "$HOME/.minirc.dfl"

Install-SystemPackage minicom

# Test on macOS if dialout is correct group
if ($IsLinux) {
    sudo usermod -a -G dialout $(whoami)
}
