#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [string]
    $ModuleName = "node"
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Setting up NodeJS'

Remove-PathModule npm

function Install-NVM () {
    Write-ColoredLine 'Installing NVM' Magenta

    if ($IsMacOS) {
        Install-SystemPackage nvm
    } else {
        if (!(Test-DirExists $HOME/.nvm)) {
            git clone "https://github.com/creationix/nvm.git" $HOME/.nvm
            Set-Location $HOME/.nvm
        } else {
            Set-Location $HOME/.nvm
            git fetch
        }
    }

    git checkout $Settings.nodejs.nvm.version

    Write-ColoredLine 'Installing Node Engines' Magenta
    zsh "$PSScriptRoot/final-setup.zsh" install $Settings.nodejs.nvm.engines
    zsh "$PSScriptRoot/final-setup.zsh" default $Settings.nodejs.nvm.default

    Add-ZshHook post '10-nvm' "$PSScriptRoot/nvm-hook.zsh"
}

function Install-Yarn () {
    Write-ColoredLine 'Installing Yarn' Magenta
    if (Test-CommandExists yarn) {
        Write-ColoredLine 'Yarn already installed' Magenta
    } else {
        if ($IsMacOS) {
            brew install yarn --without-node
        } elseif (Test-IsArch) {
            Install-SystemPackage yarn
        } elseif ($IsLinux) {
            Import-RepoKey 'https://dl.yarnpkg.com/debian/pubkey.gpg'
            Install-RepoList "$PSScriptRoot/yarn"
            Install-SystemPackage -Update yarn
        } else {
            Write-Output 'Unsupported distribution'
            return
        }
    }

    if (($Settings.nodejs.global_packages).Count -gt 0) {
        yarn global add $Settings.nodejs.global_packages
    }
}

switch ($ModuleName) {
    "yarn" { Install-Yarn }
    "nvm"  { Install-NVM }
    Default { Install-NVM; Install-Yarn }
}
