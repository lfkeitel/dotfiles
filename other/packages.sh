#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
install_packages_mac() {
    if ! cmd_exists brew; then
        echo "Installing Homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    PACKAGES=(
        zsh
        zsh-completions
        tmux
        wget
        coreutils
        grep
        vim
        bash
    )
    declare -a PACKAGES_NEEDED

    for PACKAGE in "${PACKAGES[@]}"; do
        if [[ -z "$(brew list $PACKAGE 2>/dev/null)" ]]; then
            PACKAGES_NEEDED+=("$PACKAGE")
        fi
    done

    if [ ${#PACKAGES_NEEDED} -gt 0 ]; then
        echo "Installing brew packages"
        brew install "${PACKAGES_NEEDED[@]}"
    else
        echo "No packages need to be installed"
    fi
}

LINUX_PACKAGES=(
    vim
    emacs
    curl
    zsh
    vlc
    git
    htop
    mousepad
    tmux
    xclip
    haveged
)

install_packages_linux() {
    if is_ubuntu; then
        install_with_apt
    elif is_fedora; then
        install_with_dnf
    else
        echo "Unsupported package manager"
    fi
}

install_with_apt() {
    INSTALLED_PACKAGES="$(apt list --installed 2>/dev/null)"
    declare -a PACKAGES_NEEDED

    for PACKAGE in "${LINUX_PACKAGES[@]}"; do
        if [ -z "$(echo "$INSTALLED_PACKAGES" | grep "$PACKAGE/")" ]; then
            PACKAGES_NEEDED+=("$PACKAGE")
        fi
    done

    # Install applications
    if [ ${#PACKAGES_NEEDED} -gt 0 ]; then
        printf "Installing: %s\n" "${PACKAGES_NEEDED[@]}"
        sudo apt install -y "${PACKAGES_NEEDED[@]}"
    else
        echo "No packages need to be installed"
    fi
}

install_rpmfusion_repo() {
    sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
}

install_with_dnf() {
    install_rpmfusion_repo
    LINUX_PACKAGES+=('util-linux-user')
    sudo dnf install -y ${LINUX_PACKAGES[*]}
}

install_header "Installing packages"
case "$SYSTEM_TYPE" in
    Darwin) install_packages_mac;;
    *)      install_packages_linux;;
esac
