#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GOROOT="/usr/local/go"
GOPATH="$HOME/go"

install_golang() {
    install_header "Installing Go"
    GO_VERSION="1.10"
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

    mkdir -p "$GOPATH/src"
    mkdir -p "$GOPATH/pkg"
    mkdir -p "$GOPATH/bin"

    # Remove any archive packages from older version of Go
    rm -rf "$GOPATH/pkg/*"

    finish_install
}

install_go_packages() {
    get_go github.com/golang/dep/cmd/dep
    get_go github.com/kardianos/govendor
    get_go github.com/nsf/gocode
    get_go golang.org/x/tools/cmd/goimports
    get_go golang.org/x/tools/cmd/guru
    get_go github.com/erning/gorun
    get_go golang.org/x/vgo
}

get_go() {
    $GOROOT/bin/go get -u "$1"
}

finish_install() {
    addtopath go "$GOROOT/bin" # Go binary and tools
    addtopath go "$GOPATH/bin" # Installed Go programs

    show_colored_line magenta 'Installing/updating Go packages'

    (install_go_packages) &

    echo -n -e `resolve_color_code magenta`
    waiting_dots $!
    echo -e ".Finished!\e[0m"

    show_colored_line_nl magenta 'Setting up gorun bin fmt'

    sudo mv $GOPATH/bin/gorun /usr/local/bin/
    if [[ ! -f /proc/sys/fs/binfmt_misc/golang ]]; then
        echo ':golang:E::go::/usr/local/bin/gorun:OC' | sudo tee /proc/sys/fs/binfmt_misc/register
    fi

    add_zsh_hook 'post' '10-golang' "$DIR/setuphook.zsh"
}

install_golang
