#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"

run_all() {
    $DIR/packages.sh
    $DIR/golang.sh
    $DIR/fonts.sh
    $DIR/git/install.sh
    $DIR/tmux/install.sh
    $DIR/zsh/install.sh
    $DIR/emacs/install.sh
    $DIR/gpg/install.sh
    $DIR/vscode/install.sh all
    $DIR/npm/install.sh

    if [ "$system_type" = "Darwin" ]; then
        $DIR/macos.sh
    fi
}

if [[ -z "$1" || "$1" = "all" ]]; then
    run_all
    exit
fi

case "$1" in
    packages)   $DIR/packages.sh;;
    golang)     $DIR/golang.sh;;
    fonts)      $DIR/fonts.sh;;
    git)        $DIR/git/install.sh;;
    tmux)       $DIR/tmux/install.sh;;
    zsh|shell)  $DIR/zsh/install.sh;;
    emacs)      $DIR/emacs/install.sh;;
    gpg)        $DIR/gpg/install.sh;;
    vscode)     shift; $DIR/vscode/install.sh ${@};;
    npm)        $DIR/npm/install.sh;;
    mac)        $DIR/macos.sh;;
esac
