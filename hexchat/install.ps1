#!/usr/bin/env pwsh
if (!$IsLinux) { return }
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Hexchat'

if (!(Get-IsPackageInstalled hexchat)) {
    Install-SystemPackages hexchat
}

function Install-HexFile ([string] $File) {
    Copy-Item "$PSScriptRoot/$File.conf" "$HOME/.config/hexchat/$File.conf" -Force
}

Restore-EncryptedFile "$PSScriptRoot/servlist.conf.gpg" "$HOME/.config/hexchat/servlist.conf"
Install-HexFile chanopt
Install-HexFile colors
Install-HexFile hexchat
Install-HexFile ignore
Install-HexFile notify
Install-HexFile sound
