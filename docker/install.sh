#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_docker() {
    [[ $SYSTEM_TYPE != "Linux" ]] && return
    if [[ -n $(which docker 2>/dev/null) ]]; then
        echo "Docker already installed, skipping"
        return
    fi

    if [[ $LINUX_DISTRO == "Ubuntu" ]]; then
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        export CODE_RELEASE=$(lsb_release -c | awk '{print $2}')
        sed "s/\$CODE_RELEASE/$CODE_RELEASE/" $DIR/docker.list | sudo tee /etc/apt/sources.list.d/docker.list

        sudo apt update && sudo apt install -y docker-ce
    elif [[ $LINUX_DISTRO == "Fedora" ]]; then
        sudo rpm --import https://download.docker.com/linux/fedora/gpg

        sudo cp $DIR/docker.repo /etc/yum.repos.d/docker.repo

        sudo dnf install -y docker-ce
    fi
}

install_docker
