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

function Run-Installer ([string] $Module, [string] $Name) {
    if (Test-FileExists $Module) {
        & $Module -SettingsFile $SettingsFile -ModuleName $Name @InstallerArgs
        return
    }

    $Installer = (Join-Path $PSScriptRoot $Module 'install.ps1')
    if (Test-FileExists $Installer) {
        & $Installer -SettingsFile $SettingsFile -ModuleName $Name @InstallerArgs
        return
    }

    Write-ColoredLine "No installer found for $Module." Red
}

Write-MainBanner "LEE'S DOTFILES" Blue
if ($Args.Count -eq 0) {
    foreach ($Installer in $Settings.Installers.PsObject.Properties) {
        $InstallerV = $Installer.Value
        if ($InstallerV.Autorun) {
            if ($InstallerV.Alias) {
                $AliasName = $InstallerV.Alias
                $InstallerV = $Settings.Installers.($InstallerV.Alias)
                if (!(Get-Member -InputObject $InstallerV 'Path')) {
                    Add-Member -InputObject $InstallerV -Type NoteProperty -Name "Path" -Value $AliasName
                }
            }

            if ($InstallerV.Path) {
                Run-Installer $InstallerV.Path $Installer.Name
            } else {
                Run-Installer $Installer.Name $Installer.Name
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
        Write-ColoredLine "No installer configured for $Name." Red
        Exit 1
    }

    if ($Installer.Alias) {
        $AliasName = $Installer.Alias
        $Installer = $Settings.Installers.($Installer.Alias)
        if (!(Get-Member -InputObject $Installer 'Path')) {
            Add-Member -InputObject $Installer -Type NoteProperty -Name "Path" -Value $AliasName
        }
    }

    if ($Installer.Path) {
        Run-Installer $Installer.Path $Name
    } else {
        Run-Installer $Name $Name
    }
}
