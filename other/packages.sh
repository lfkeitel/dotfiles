#!/usr/bin/env bash
system_type="$(uname)"

install_packages_mac() {
    echo "Installing Homebrew"

    if [ -z "$(which brew 2>/dev/null)" ]; then
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

install_packages_linux() {
    PACKAGES=(
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
    )
    INSTALLED_PACKAGES="$(apt list --installed 2>/dev/null)"
    declare -a PACKAGES_NEEDED

    for PACKAGE in "${PACKAGES[@]}"; do
        if [ -z "$(echo "$INSTALLED_PACKAGES" | grep "$PACKAGE/")" ]; then
            PACKAGES_NEEDED+=("$PACKAGE")
        fi
    done

    # Install applications
    if [ ${#PACKAGES_NEEDED} -gt 0 ]; then
        printf "Installing: %s\n" "${PACKAGES_NEEDED[@]}"
        sudo apt install "${PACKAGES_NEEDED[@]}"
    else
        echo "No packages need to be installed"
    fi
}

echo "Installing packages"
case "$system_type" in
    Darwin) install_packages_mac;;
    *)      install_packages_linux;;
esac
