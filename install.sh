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

declare -A installScripts
installScripts['zsh']=$DIR/zsh/install.sh
installScripts['packages']=$DIR/other/packages.sh
installScripts['golang']=$DIR/golang/install.sh
installScripts['fonts']=$DIR/other/fonts.sh
installScripts['git']=$DIR/git/install.sh
installScripts['tmux']=$DIR/tmux/install.sh
installScripts['emacs']=$DIR/emacs/install.sh
installScripts['gpg']=$DIR/gpg/install.sh
installScripts['vscode']=$DIR/vscode/install.sh
installScripts['npm']=$DIR/npm/install.sh
installScripts['macos']=$DIR/other/macos.sh

run_all() {
    ${installScripts['zsh']}
    ${installScripts['packages']}
    ${installScripts['golang']}
    ${installScripts['fonts']}
    ${installScripts['git']}
    ${installScripts['tmux']}
    ${installScripts['emacs']}
    ${installScripts['gpg']}
    ${installScripts['vscode']}
    ${installScripts['npm']}

    if [ "$system_type" = 'Darwin' ]; then
        ${installScripts['macos']}
    fi
}

if [[ -z "$1" || "$1" = 'all' ]]; then
    run_all
    exit
fi

case "$1" in
    zsh|shell)  ${installScripts['zsh']};;
    packages)   ${installScripts['packages']};;
    golang)     ${installScripts['golang']};;
    fonts)      ${installScripts['fonts']};;
    git)        ${installScripts['git']};;
    tmux)       ${installScripts['tmux']};;
    emacs)      ${installScripts['emacs']};;
    gpg)        ${installScripts['gpg']};;
    vscode)     shift; ${installScripts['vscode']} ${@};;
    npm)        ${installScripts['npm']};;
    mac)        ${installScripts['macos']};;
esac
