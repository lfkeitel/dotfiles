#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_packages() {
    PACKAGES=( vim emacs curl zsh vlc git )
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
    fi
}

setup_gpg_agent() {
    INSTALLED_FILE="$HOME/.gnupg/.dotfile-installed.1"
    if [ -f "$INSTALLED_FILE" ]; then return; fi

    # Install packages for gpg-agent and smartcards
    sudo apt install gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    mkdir -p "$HOME/.gnupg"
    echo "use-agent" > "$HOME/.gnupg/gpg.conf"
    echo "keyserver keys.fedoraproject.org" >> "$HOME/.gnupg/gpg.conf"

    # Import my public key and trust it ultimately
    gpg2 --recv-keys E638625F
    trust_str="$(gpg --list-keys --fingerprint | grep 'E638 625F' | tr -d '[:space:]' | awk '{ print $1 ":6:"}')"
    echo "$trust_str" | gpg2 --import-ownertrust

    # Idempotency
    rm -f "$HOME/.gnupg/.dotfile-installed.*"
    touch "$INSTALLED_FILE"
}

install_code_fonts() {
    RELOAD_FONT=0
    if [ ! -f /usr/local/share/fonts/Inconsolata-Regular.ttf ]; then
        wget https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf
        sudo mv Inconsolata-Regular.ttf /usr/local/share/fonts/
        RELOAD_FONT=1
    fi

    if [ ! -f /usr/local/share/fonts/Inconsolata-Bold.ttf ]; then
        wget https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf
        sudo mv Inconsolata-Bold.ttf /usr/local/share/fonts/
        RELOAD_FONT=1
    fi

    if [ $RELOAD_FONT -eq 1 ]; then
        fc-cache -f
    fi
}

link_emacs_config() {
    mkdir -p "$HOME/.emacs.d"
    ln -sfn "$DIR/emacs/.emacs.d/config" "$HOME/.emacs.d/config"
    ln -sfn "$DIR/emacs/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
    ln -sfn "$DIR/emacs/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

    # Create org directory and index file
    mkdir -p "$HOME/org"
    touch "$HOME/org/index.org"
}

link_git_config() {
    ln -sfn "$DIR/git/.gitconfig" "$HOME/.gitconfig"
    ln -sfn "$DIR/git/.gitignore" "$HOME/.gitignore"
    ln -sfn "$DIR/git/.gitmessage" "$HOME/.gitmessage"
}

link_zsh_config() {
    ln -sfn "$DIR/zsh/.zshrc" "$HOME/.zshrc"
    ln -sfn "$DIR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        "$DIR/install-oh-my-zsh.sh"
    fi
}

install_golang() {
    # Permanent GOPATH is defined in .zshrc
    GO_VERSION="1.8.3"
    GO_INSTALLED="$(go version | cut -d' ' -f3)"

    if [ "go$GO_VERSION" == $GO_INSTALLED ]; then return; fi
    wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
    rm -f go$GO_VERSION.linux-amd64.tar.gz

    GOPATH="$HOME/go"
    go="/usr/local/go/bin/go"

    $go get -u github.com/kardianos/govendor
    $go get -u github.com/nsf/gocode
    $go get -u golang.org/x/tools/cmd/goimports
    $go get -u github.com/tools/godep
    $go get -u github.com/golang/dep/cmd/dep
    $go get -u golang.org/x/tools/cmd/guru
}

install_packages
install_code_fonts
link_emacs_config
link_git_config
link_zsh_config
install_golang
setup_gpg_agent
