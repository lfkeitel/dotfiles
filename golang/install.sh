#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GOROOT="/usr/local/go"

install_golang() {
    install_header "Installing Go"
    GO_VERSION="1.9.3"
    GO_INSTALLED="$($GOROOT/bin/go version 2> /dev/null | cut -d' ' -f3)"

    if [ "go$GO_VERSION" == "$GO_INSTALLED" ]; then
        show_colored_line_nl green "Go is at requested version $GO_VERSION"
        finish_install
        exit
    fi

    show_warning_msg "Installed: $GO_INSTALLED"
    show_warning_msg "Wanted:    go$GO_VERSION"

    if is_macos; then
        show_warning_msg "macOS detected, please install/upgrade Go"
        exit
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

    finish_install
}

install_go_packages() {
    $GOROOT/bin/go get -u github.com/kardianos/govendor
    $GOROOT/bin/go get -u github.com/nsf/gocode
    $GOROOT/bin/go get -u golang.org/x/tools/cmd/goimports
    $GOROOT/bin/go get -u github.com/tools/godep
    $GOROOT/bin/go get -u github.com/golang/dep/cmd/dep
    $GOROOT/bin/go get -u golang.org/x/tools/cmd/guru
}

finish_install() {
    addtopath go "$GOROOT/bin" # Go binary and tools
    addtopath go "$GOPATH/bin" # Installed Go programs

    show_colored_line magenta 'Installing Go packages'

    (install_go_packages) &

    echo -n -e `resolve_color_code magenta`
    waiting_dots $!
    echo -e ".Finished!\e[0m"

    add_zsh_hook 'post' '10-golang' "$DIR/setuphook.zsh"
}

install_golang
