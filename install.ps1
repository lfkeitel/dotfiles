#!/usr/bin/env pwsh
if ($IsWindows) {
    Write-Output "These dotfiles are written for Linux and macOS only"
    return
}

Set-Location $PSScriptRoot

Import-Module (Join-Path $PSScriptRoot Utils)

$SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
$Settings = Get-JSONFile $SettingsFile

$InstallerArgs = $Args[1..($Args.Length-1)]

function Run-Installer ([string] $Module) {
    $Installer = (Join-Path $PSScriptRoot $Module 'install.ps1')
    if (Test-FileExists $Installer) {
        & $Installer -SettingsFile $SettingsFile @InstallerArgs
        return
    }

    $Installer = (Join-Path $PSScriptRoot 'other' "$Module.ps1")
    if (Test-FileExists $Installer) {
        & $Installer -SettingsFile $SettingsFile @InstallerArgs
        return
    }

    Write-Output "No installer for $Module."
}

Write-MainBanner "LEE'S DOTFILES" Blue
if ($Args.Count -eq 0) {
    foreach ($Installer in $Settings.defaultInstallers) {
        Run-Installer $Installer
    }

    if ($IsMacOS) {
        Run-Installer macos
    }
} else {
    Run-Installer $Args[0]
}
