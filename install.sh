#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_packages() {
    echo "Installing packages"
    PACKAGES=( vim emacs curl zsh vlc git texlive-base texlive-bibtex-extra texlive-fonts-recommended texlive-latex-base texlive-latex-extra texlive-latex-recommended htop mousepad tmux xclip )
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

setup_gpg_agent() {
    echo "Setting up GPG agent"
    INSTALLED_FILE="$HOME/.gnupg/.dotfile-installed.1"
    if [ -f "$INSTALLED_FILE" ]; then
        echo "GPG already setup"
        return
    fi

    # Install packages for gpg-agent and smartcards
    sudo apt install gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    mkdir -p "$HOME/.gnupg"
    echo "use-agent" > "$HOME/.gnupg/gpg.conf"
    echo "keyserver keys.fedoraproject.org" >> "$HOME/.gnupg/gpg.conf"
    chmod -R og-rwx "$HOME/.gnupg"

    # Import my public key and trust it ultimately
    gpg2 --recv-keys E638625F
    trust_str="$(gpg2 --list-keys --fingerprint | grep 'E638 625F' | tr -d '[:space:]' | awk '{ print $1 ":6:"}')"
    echo "$trust_str" | gpg2 --import-ownertrust

    # Idempotency
    rm -f "$HOME/.gnupg/.dotfile-installed.*"
    touch "$INSTALLED_FILE"
}

install_code_fonts() {
    echo "Install Inconsolata font"
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
    echo "Setting up Emacs"
    mkdir -p "$HOME/.emacs.d"
    ln -sfn "$DIR/emacs/.emacs.d/config" "$HOME/.emacs.d/config"
    ln -sfn "$DIR/emacs/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
    ln -sfn "$DIR/emacs/.emacs.d/org-templates" "$HOME/.emacs.d/org-templates"
    ln -sfn "$DIR/emacs/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

    # Create org directory and index file
    mkdir -p "$HOME/org"
    touch "$HOME/org/index.org"
}

link_git_config() {
    echo "Setting up Git"
    ln -sfn "$DIR/git/.gitconfig" "$HOME/.gitconfig"
    ln -sfn "$DIR/git/.gitignore" "$HOME/.gitignore"
    ln -sfn "$DIR/git/.gitmessage" "$HOME/.gitmessage"
}

link_tmux_config() {
    echo "Setting up tmux"
    ln -sfn "$DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
}

link_zsh_config() {
    echo "Setting up ZSH"
    ln -sfn "$DIR/zsh/.zshrc" "$HOME/.zshrc"
    ln -sfn "$DIR/zsh/.zsh_aliases" "$HOME/.zsh_aliases"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh"
        "$DIR/install-oh-my-zsh.sh"
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}"
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$ZSH_CUSTOM/plugins/project" ]; then
        git clone https://github.com/lfkeitel/project-list.git $ZSH_CUSTOM/plugins/project
    fi

    mkdir -p "$ZSH_CUSTOM/themes"
    ln -sfn "$DIR/zsh/gnzh.zsh-theme" "$ZSH_CUSTOM/themes/gnzh.zsh-theme"
}

install_golang() {
    echo "Installing Go"
    GO_VERSION="1.9"
    GO_INSTALLED="$(go version 2> /dev/null | cut -d' ' -f3)"
    GOROOT="/usr/local/go"

    if [ "go$GO_VERSION" == "$GO_INSTALLED" ]; then
        echo "Go is at requested version $GO_VERSION"
        return
    fi

    if [ ! -f "go$GO_VERSION.linux-amd64.tar.gz" ]; then
        wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz
    fi

    if [ -d "$GOROOT" ]; then
        sudo rm -rf "$GOROOT"
    fi

    sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
    rm -f go$GO_VERSION.linux-amd64.tar.gz

    GOPATH="$HOME/go"
    go="$GOROOT/bin/go"

    mkdir -p "$GOPATH/src"
    mkdir -p "$GOPATH/pkg"
    mkdir -p "$GOPATH/bin"

    # Remove any archive packages from older version of Go
    rm -rf "$GOPATH/pkg/*"

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
link_tmux_config
install_golang
setup_gpg_agent
