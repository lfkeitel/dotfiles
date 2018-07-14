#!/usr/bin/env pwsh
if (!$IsLinux) { return }
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Hexchat'

if (!(Get-IsPackageInstalled hexchat)) {
    Install-SystemPackages hexchat
}

$HexConfigDir = "$HOME/.config/hexchat"

function Install-HexFile ([string] $File) {
    Copy-Item "$PSScriptRoot/$File.conf" "$HexConfigDir/$File.conf" -Force
}

function Install-HexFileEncrypted ([string] $File) {
    Restore-EncryptedFile "$PSScriptRoot/$File.conf.gpg" "$HexConfigDir/$File.conf"
}

Install-HexFileEncrypted servlist
Install-HexFile chanopt
Install-HexFile colors
Install-HexFile hexchat
Install-HexFile ignore
Install-HexFile notify
Install-HexFile sound
