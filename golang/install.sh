#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GOROOT="/usr/local/go"

install_golang() {
    echo "Installing Go"
    GO_VERSION="1.9.3"
    GO_INSTALLED="$($GOROOT/bin/go version 2> /dev/null | cut -d' ' -f3)"

    if [ "go$GO_VERSION" == "$GO_INSTALLED" ]; then
        echo "Go is at requested version $GO_VERSION"
        finish_install
        return
    fi

    echo "Installed: $GO_INSTALLED"
    echo "Wanted:    go$GO_VERSION"

    if is_macos; then
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

    mkdir -p "$GOPATH/{src,pkg,bin}"

    # Remove any archive packages from older version of Go
    rm -rf "$GOPATH/pkg/*"

    finish_install
}

install_go_packages() {
    echo "Installing Go packages"

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
    install_go_packages
    add_zsh_hook 'post' '10-golang' "$DIR/setuphook.zsh"
}

install_golang
