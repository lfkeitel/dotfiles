#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

function Install-Homebrew {
    if (!(Get-CommandExists brew)) {
        Write-Output 'Installing Homebrew'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }
}

function Install-MacPackages {
    Install-Homebrew
    brew install $Settings.packages.macos
}

function Install-Aurman {
    if (!(Get-IsArch) -or (Get-CommandExists aurman)) { return }

    New-Directory "$HOME/code"

    if (Test-DirExists $HOME/code/aurman) {
        Set-Location $HOME/code/aurman
        git fetch
    } else {
        git clone 'https://aur.archlinux.org/aurman.git' $HOME/code/aurman
        Set-Location $HOME/code/aurman
    }

    makepkg -Acs
    sudo pacman -U *.pkg.tar.xz
}

function Install-LinuxPackages {
    if (Get-IsFedora) {
        Install-SystemPackages "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
        Install-SystemPackages $Settings.packages.linux $Settings.packages.fedora
    } elseif (Get-IsUbuntu) {
        Install-SystemPackages $Settings.packages.linux $Settings.packages.ubuntu
    } elseif (Get-IsArch) {
        Install-Aurman
        Install-SystemPackages $Settings.packages.linux $Settings.packages.arch

        Write-ColoredLine "Remember to add personal repo to pacman and install wanted packages" Red
    }

    sudo systemctl start haveged
    sudo systemctl enable haveged
}

Write-Header 'Installing packages'
if ($IsMacOS) { Install-MacPackages }
elseif ($IsLinux) { Install-LinuxPackages }
