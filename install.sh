#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

install_packages() {
    echo "Installing packages"
    case "$system_type" in
    Darwin)
        install_packages_mac
        ;;
    *)
        install_packages_linux
        ;;
    esac
}

install_packages_mac() {
    echo "Installing Homebrew"

    if [ -z "$(which brew 2>/dev/null)" ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    echo "Installing brew packages"
    brew install zsh zsh-completions tmux gpg-agent gpg2 pidof wget
}

install_packages_linux() {
    PACKAGES=(
        vim
        emacs
        curl
        zsh
        vlc
        git
        texlive-base
        texlive-bibtex-extra
        texlive-fonts-recommended
        texlive-latex-base
        texlive-latex-extra
        texlive-latex-recommended
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

setup_gpg_agent() {
    echo "Setting up GPG agent"
    INSTALLED_FILE="$HOME/.gnupg/.dotfile-installed.1"

    if [ ! -e /usr/local/bin/gpg2 ]; then
        sudo ln -s /usr/bin/gpg2 /usr/local/bin/gpg2
    fi

    if [ -f "$INSTALLED_FILE" ]; then
        echo "GPG already setup"
        return
    fi

    # Install packages for gpg-agent and smartcards
    if [ "$system_type" != "Darwin" ]; then
        sudo apt install gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    fi
    mkdir -p "$HOME/.gnupg"
    echo "use-agent" > "$HOME/.gnupg/gpg.conf"
    echo "keyserver keys.fedoraproject.org" >> "$HOME/.gnupg/gpg.conf"
    if [ "$(uname)" != "Darwin" ]; then
        cp "$DIR/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
    fi
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
    case "$system_type" in
    Darwin)
        install_code_fonts_mac
        ;;
    *)
        install_code_fonts_linux
        ;;
    esac
}

install_code_fonts_linux() {
    echo "Install Inconsolata font"
    RELOAD_FONT=0

    library="/usr/local/share/fonts"
    regular_font_out="$library/Inconsolata-Regular.ttf"
    bold_font_out="$library/Inconsolata-Bold.ttf"

    regular_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"
    bold_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"

    if [ ! -f $regular_font_out ]; then
        sudo wget -O $regular_font_out $regular_font
        RELOAD_FONT=1
    fi

    if [ ! -f $bold_font_out ]; then
        sudo wget -O $bold_font_out $bold_font
        RELOAD_FONT=1
    fi

    if [ $RELOAD_FONT -eq 1 ]; then
        fc-cache -f
    fi
}

install_code_fonts_mac() {
    echo "Install Inconsolata font"

    library="$HOME/Library/Fonts"
    regular_font_out="$library/Inconsolata-Regular.ttf"
    bold_font_out="$library/Inconsolata-Bold.ttf"

    regular_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"
    bold_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"

    if [ ! -f $regular_font_out ]; then
        wget -O $regular_font_out $regular_font
    fi

    if [ ! -f $bold_font_out ]; then
        wget -O $bold_font_out $bold_font
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
    ln -sfn "$DIR/zsh/.zsh_functions" "$HOME/.zsh_functions"

    # oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing oh-my-zsh"
        "$DIR/install-oh-my-zsh.sh"

        # On Mac, set zsh as default
        if [ "$system_type" = "Darwin" ]; then
            sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
        fi
    fi

    ZSH_CUSTOM="${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}"

    # Plugins
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi

    pushd "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git pull
    popd

    if [ ! -d "$ZSH_CUSTOM/plugins/project" ]; then
        git clone https://github.com/lfkeitel/project-list.git "$ZSH_CUSTOM/plugins/project"
    fi

    pushd "$ZSH_CUSTOM/plugins/project"
    git pull
    popd

    mkdir -p "$ZSH_CUSTOM/plugins/docker-host"
    ln -sfn "$DIR/zsh/docker-host.sh" "$ZSH_CUSTOM/plugins/docker-host/docker-host.plugin.zsh"

    # Theme
    mkdir -p "$ZSH_CUSTOM/themes"
    if [ -h "$ZSH_CUSTOM/themes/gnzh.zsh-theme" ]; then # Remove this if once all machines have been updated
        rm "$ZSH_CUSTOM/themes/gnzh.zsh-theme"
    fi
    ln -sfn "$DIR/zsh/lfk.zsh-theme" "$ZSH_CUSTOM/themes/lfk.zsh-theme"
}

install_golang() {
    echo "Installing Go"
    GO_VERSION="1.9.1"
    GO_INSTALLED="$(go version 2> /dev/null | cut -d' ' -f3)"
    GOROOT="/usr/local/go"

    if [ "go$GO_VERSION" == "$GO_INSTALLED" ]; then
        echo "Go is at requested version $GO_VERSION"
        install_go_packages
        return
    fi

    if [ "$system_type" = "Darwin" ]; then
        echo "macOS detected, please install/upgrade Go"
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

    mkdir -p "$GOPATH/src"
    mkdir -p "$GOPATH/pkg"
    mkdir -p "$GOPATH/bin"

    # Remove any archive packages from older version of Go
    rm -rf "$GOPATH/pkg/*"

    install_go_packages
}

install_go_packages() {
    echo "Installing Go packages"

    go get -u github.com/kardianos/govendor
    go get -u github.com/nsf/gocode
    go get -u golang.org/x/tools/cmd/goimports
    go get -u github.com/tools/godep
    go get -u github.com/golang/dep/cmd/dep
    go get -u golang.org/x/tools/cmd/guru
}

setup_mac_finder() {
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder /System/Library/CoreServices/Finder.app
}

setup_vscode() {
    echo "Setting up Visual Studio Code"
    runInstall="no"
    runLinks="no"
    runExtInstall="no"

    [[ "$1" = "all" || "$1" = "install" ]] && runInstall="yes"
    [[ "$1" = "all" || "$1" = "link" ]] && runLinks="yes"
    [[ "$1" = "all" || "$1" = "ext" ]] && runExtInstall="yes"

    if [[ $runInstall = "yes" && -z "$(which code 2>/dev/null)" ]]; then
        if [ "$system_type" = "Darwin" ]; then
            # TODO: Install VSCode: http://commandlinemac.blogspot.com/2008/12/installing-dmg-application-from-command.html
            echo "Please install VS Code first"
            return
        else
            wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
            sudo dpkg -i vscode.deb
            sudo apt install -f
        fi
    fi

    if [[ $runLinks = "yes" ]]; then
        settingsPath="$HOME/.config/Code/User"
        if [ "$system_type" = "Darwin" ]; then
            settingsPath="$HOME/Library/Application Support/Code/User"
        fi

        ln -sfn "$DIR/vscode/settings.json" "$settingsPath/settings.json"
        ln -sfn "$DIR/vscode/keybindings.json" "$settingsPath/keybindings.json"

        if [[ -e "$settingsPath/snippets" ]]; then
            rm -rf "$settingsPath/snippets"
        fi
        ln -sfn "$DIR/vscode/snippets" "$settingsPath"
    fi

    # Install extensions
    vscode_exts=(
        bungcip.better-toml
        ms-vscode.cpptools
        ms-vscode.csharp
        akamud.vscode-caniuse
        wesbos.theme-cobalt2
        naumovs.color-highlight
        anseki.vscode-color
        msjsdiag.debugger-for-chrome
        PeterJausovec.vscode-docker
        EditorConfig.editorconfig
        dbaeumer.vscode-eslint
        donjayamanne.githistory
        eamodio.gitlens
        felipecaputo.git-project-manager
        HookyQR.githubissues
        lukehoban.go
        casualjim.gotemplate
        oderwat.indent-rainbow
        wholroyd.jinja
        redhat.java
        Ionide.ionide-fsharp
        lfkeitel.language-nitrogen
        techer.open-in-browser
        christian-kohler.path-intellisense
        felixfbecker.php-intellisense
        alefragnani.project-manager
        donjayamanne.python
        2gua.rainbow-brackets
        kalitaalexey.vscode-rust
        swyphcosmo.spellchecker
        rashwell.tcl
        eg2.tslint
        robertohuertasm.vscode-icons
        MattiasPernhult.vscode-todo
        jsynowiec.vscode-insertdatestring
        bibhasdn.unique-lines
        formulahendry.auto-close-tag
        sysoev.language-stylus
        formulahendry.auto-rename-tag
    )

    if [[ $runExtInstall = "yes" ]]; then
        for ext in "${vscode_exts[@]}"; do
            code --install-extension "$ext"
        done
    fi
}

run_all() {
    install_packages
    install_golang
    install_code_fonts
    link_git_config
    link_tmux_config
    link_zsh_config
    link_emacs_config
    setup_gpg_agent
    setup_vscode all

    if [ "$system_type" = "Darwin" ]; then
        setup_mac_finder
    fi
}

if [[ -z "$1" || "$1" = "all" ]]; then
    run_all
    exit 0
fi

case "$1" in
    packages)
        install_packages;;
    golang)
        install_golang;;
    fonts)
        install_code_fonts;;
    git)
        link_git_config;;
    tmux)
        link_tmux_config;;
    zsh|shell)
        link_zsh_config;;
    emacs)
        link_emacs_config;;
    gpg)
        setup_gpg_agent;;
    vscode)
        shift
        setup_vscode ${@};;
    mac)
        setup_mac_finder;;
esac
