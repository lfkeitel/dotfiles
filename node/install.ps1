#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Setting up NodeJS'

Remove-PathModule npm

Write-ColoredLine 'Installing NVM' Magenta

if ($IsMacOS) {
    Install-SystemPackages nvm
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

Write-ColoredLine 'Installing Yarn' Magenta
if (Get-CommandExists yarn) {
    Write-ColoredLine 'Yarn already installed' Magenta
} else {
    if ($IsMacOS) {
        brew install yarn --without-node
    } elseif ($IsLinux) {
        Import-RepoKey 'https://dl.yarnpkg.com/debian/pubkey.gpg'
        Install-RepoList "$PSScriptRoot/yarn"
        Install-SystemPackages -Update yarn
    } else {
        Write-Output 'Unsupported distribution'
        return
    }
}

Add-ZshHook post '10-nvm' "$PSScriptRoot/nvm-hook.zsh"
