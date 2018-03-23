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
}

if ($Args.Count -eq 0) {
    # packages
    # zsh
    # golang
    # fonts
    # git
    # tmux
    # emacs
    # gpg
    # vscode
    # npm
    # vim

    # if ($IsMacOS) {
    #   macos
    # }
    Write-Output "Running all modules is not supported at this time."
    exit 1
}

Write-MainBanner "Lee's Dotfiles" Blue

$Module = $Args[0]

if ($InstallScripts.Contains($Module)) {
    $Installer = $InstallScripts.$Module
    if (Test-FileExists $Installer) {
        pwsh $InstallScripts.$Module ($Args | Select-Object -Skip 1)
    } else {
        Write-Output "Module $Module doesn't have an install script yet."
    }
} else {
    Write-Output "No installer for $Module."
    exit 1
}
