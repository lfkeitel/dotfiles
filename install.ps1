#!/usr/bin/env pwsh
Set-Location $PSScriptRoot

Import-Module (Join-Path (Get-Location) Utils)

$InstallScripts = @{
    zsh = (Join-Path (Get-Location) zsh install.ps1)
    packages = (Join-Path (Get-Location) other packages.ps1)
    golang = (Join-Path (Get-Location) golang install.ps1)
    fonts = (Join-Path (Get-Location) other fonts.ps1)
    git = (Join-Path (Get-Location) git install.ps1)
    tmux = (Join-Path (Get-Location) tmux install.ps1)
    emacs = (Join-Path (Get-Location) emacs install.ps1)
    gpg = (Join-Path (Get-Location) gpg install.ps1)
    vscode = (Join-Path (Get-Location) vscode install.ps1)
    npm = (Join-Path (Get-Location) npm install.ps1)
    macos = (Join-Path (Get-Location) other macos.ps1)
    vim = (Join-Path (Get-Location) vim install.ps1)
    docker = (Join-Path (Get-Location) docker install.ps1)
    hexchat = (Join-Path (Get-Location) hexchat install.ps1)
    powershell = (Join-Path (Get-Location) powershell install.ps1)
    dart = (Join-Path (Get-Location) other dartlang.ps1)
}

$InstallerArgs = ($Args | Select-Object -Skip 1)

function Run-Installer ([string] $Module) {
    if ($InstallScripts.Contains($Module)) {
        $Installer = $InstallScripts.$Module
        if (Test-FileExists $Installer) {
            & $InstallScripts.$Module $InstallerArgs
        } else {
            Write-Output "Module $Module doesn't have an install script yet."
        }
    } else {
        Write-Output "No installer for $Module."
    }
}

Write-MainBanner "LEE'S DOTFILES" Blue
if ($Args.Count -eq 0) {
    $Installers = @(
        'packages'
        'zsh'
        'powershell'
        'golang'
        'fonts'
        'git'
        'tmux'
        'gpg'
        'vscode'
        'npm'
        'vim'
    )

    foreach ($Installer in $Installers) {
        Run-Installer $Installer
    }

    if ($IsMacOS) {
        Run-Installer macos
    }
} else {
    Run-Installer $Args[0]
}
