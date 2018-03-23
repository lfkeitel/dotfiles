#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

function Install-Homebrew {
    if (!(Get-CommandExists brew)) {
        Write-Output 'Installing Homebrew'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    }
}

function Install-MacPackages {
    Install-Homebrew

    [string[]]$Packages = @(
        'zsh',
        'zsh-completions',
        'tmux',
        'wget',
        'coreutils',
        'grep',
        'vim',
        'bash'
    )
    brew install $Packages
}

[string[]]$LinuxPackages = @(
    'zsh',
    'tmux',
    'vim',
    'emacs',
    'curl',
    'vlc',
    'git',
    'htop',
    'mousepad',
    'xclip',
    'haveged',
    'jq'
)

function Install-LinuxPackages {
    if (Get-IsUbuntu) { Install-WithApt }
    elseif (Get-IsFedora) { Install-WithDnf }
    else { Write-Output 'Unsupported package manager' }

    sudo systemctl start haveged
    sudo systemctl enable haveged
}

function Install-WithApt {
    sudo apt install -y "$LinuxPackages"
}

function Install-RPMFusionRepo {
    sudo dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
}

function Install-WithDnf {
    Install-RPMFusionRepo
    sudo dnf install -y $LinuxPackages 'util-linux-user'
}

Write-Header 'Installing packages'
if ($IsMacOS) { Install-MacPackages }
elseif ($IsLinux) { Install-LinuxPackages }
