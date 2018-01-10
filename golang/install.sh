#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"
GOROOT="/usr/local/go"

install_golang() {
    echo "Installing Go"
    GO_VERSION="1.9.2"
    GO_INSTALLED="$($GOROOT/bin/go version 2> /dev/null | cut -d' ' -f3)"

    if [ "go$GO_VERSION" == "$GO_INSTALLED" ]; then
        echo "Go is at requested version $GO_VERSION"
        finish_install
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

    finish_install
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

finish_install() {
    addtopath go "$GOROOT/bin" # Go binary and tools
    addtopath go "$GOPATH/bin" # Installed Go programs
    install_go_packages
    add_zsh_hook 'post' '10-golang' "$DIR/setuphook.zsh"
}

install_golang
