#!/bin/bash
system_type="$(uname)"

install_golang() {
    echo "Installing Go"
    GO_VERSION="1.9.2"
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

install_golang
