#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"
export TMP_PATHS_DIR='./tmp-paths'

mkdir -p "$TMP_PATHS_DIR"

addtopath() {
    module="$1"
    path="$2"
    pathfile="$TMP_PATHS_DIR/40-$module"

    echo "$path" >> $pathfile
}
export -f addtopath

add_zsh_hook() {
    hook="$1"
    hookname="$2"
    hookfile="$3"

    echo "Adding $hookname to ZSH $hook hooks"

    mkdir -p "$HOME/.local.zsh.d/$hook"
    ln -sfn "$hookfile" "$HOME/.local.zsh.d/$hook/$hookname.zsh"
}
export -f add_zsh_hook

rm_zsh_hook() {
    hook="$1"
    hookname="$2"
    hookpath="$HOME/.local.zsh.d/$hook/$hookname.zsh"

    echo "Removing $hookname from ZSH $hook hooks"

    [ -f "$hookpath" ] && rm -rf "$hookpath"
}
export -f rm_zsh_hook

zsh_hook_exists() {
    hook="$1"
    hookname="$2"
    hookpath="$HOME/.local.zsh.d/$hook/$hookname.zsh"

    [ -f "$hookpath" ]
    return $?
}
export -f zsh_hook_exists

finish() {
    file_count="$(ls -l $TMP_PATHS_DIR | wc -l)"
    if [ -d "$HOME/.local.zsh.d/paths" -a $file_count -gt 1 ]; then
        cp -r $TMP_PATHS_DIR/* "$HOME/.local.zsh.d/paths/"
    fi
    rm -rf "$TMP_PATHS_DIR"
}
trap finish EXIT

run_all() {
    $DIR/zsh/install.sh
    $DIR/packages.sh
    $DIR/golang/install.sh
    $DIR/fonts.sh
    $DIR/git/install.sh
    $DIR/tmux/install.sh
    $DIR/emacs/install.sh
    $DIR/gpg/install.sh
    $DIR/vscode/install.sh all
    $DIR/npm/install.sh

    if [ "$system_type" = 'Darwin' ]; then
        $DIR/macos.sh
    fi
}

if [[ -z "$1" || "$1" = 'all' ]]; then
    run_all
    exit
fi

case "$1" in
    packages)   $DIR/packages.sh;;
    golang)     $DIR/golang/install.sh;;
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
