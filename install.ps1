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
    if (Test-FileExists $Module) {
        & $Module -SettingsFile $SettingsFile @InstallerArgs
        return
    }

    $Installer = (Join-Path $PSScriptRoot $Module 'install.ps1')
    if (Test-FileExists $Installer) {
        & $Installer -SettingsFile $SettingsFile @InstallerArgs
        return
    }

    Write-ColoredLine "No installer for $Module." Red
}

Write-MainBanner "LEE'S DOTFILES" Blue
if ($Args.Count -eq 0) {
    foreach ($Installer in $Settings.Installers.PsObject.Properties) {
        $InstallerV = $Installer.Value
        if ($InstallerV.Autorun) {
            if ($InstallerV.Path) {
                Run-Installer $InstallerV.Path
            } else {
                Run-Installer $Installer.Name
            }
        }
    }

    if ($IsMacOS) {
        Run-Installer $Settings.Installers.macos.Path
    }
} else {
    $Name = $Args[0]
    $Installer = $Settings.Installers.($Name)
    if (!$Installer) {
        Write-ColoredLine "No installer for $Name." Red
        Exit 1
    }

    if ($Installer.Path) {
        Run-Installer $Installer.Path
    } else {
        Run-Installer $Name
    }
}
