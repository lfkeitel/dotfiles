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

if [[ $SYSTEM_TYPE == "Darwin" ]]; then
    brew tap caskroom/cask
    brew cask install powershell
elif [[ $LINUX_DISTRO == "Ubuntu" ]]; then
    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/17.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
    sudo apt-get update
    sudo apt-get install -y powershell
elif [[ $LINUX_DISTRO == "Fedora" ]]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo
    sudo dnf update
    sudo dnf install compat-openssl10
    sudo dnf install -y powershell
fi
