#!/usr/bin/env bash

SYSTEM_TYPE="$(uname)"
LINUX_DISTRO=""
if [[ $SYSTEM_TYPE == "Linux" ]]; then
    LINUX_DISTRO="$(gawk -F= '/^NAME/{print $2}' /etc/os-release 2>/dev/null | tr -d '"')"
fi

if [[ -n "$(which pwsh)" ]]; then
    echo "Powershell looks to already be installed"
    exit
fi

install_aur_helper() {
    mkdir -p "$HOME/code"
    if [[ -d "$HOME/code/yay" ]]; then
        cd "$HOME/code/yay"
        git fetch
    else
        git clone 'https://aur.archlinux.org/yay-bin.git' "$HOME/code/yay"
        cd "$HOME/code/yay"
    fi

    makepkg -Acs
    sudo pacman -U *.pkg.tar.xz
}

if [[ $SYSTEM_TYPE == "Darwin" ]]; then
    brew tap caskroom/cask
    brew cask install powershell
elif [[ $LINUX_DISTRO == "Ubuntu" ]]; then
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
    sudo apt-get update
    sudo apt-get install -y powershell
elif [[ $LINUX_DISTRO == "Fedora" ]]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    sudo dnf update
    sudo dnf install -y compat-openssl10 powershell
elif [[ $LINUX_DISTRO == "Arch Linux" ]]; then
    install_aur_helper
    yay -S powershell-bin
else
    echo "I don't know how to install PowerShell on this system."
    echo "Please consult the official documentation."
fi
