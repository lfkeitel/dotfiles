#!/usr/bin/env bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/utils.sh

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
installScripts['vim']=$DIR/vim/install.sh
installScripts['docker']=$DIR/docker/install.sh

run_all() {
    ${installScripts['packages']}
    ${installScripts['zsh']}
    ${installScripts['golang']}
    ${installScripts['fonts']}
    ${installScripts['git']}
    ${installScripts['tmux']}
    ${installScripts['emacs']}
    ${installScripts['gpg']}
    ${installScripts['vscode']}
    ${installScripts['npm']}
    ${installScripts['vim']}

    if [ "$SYSTEM_TYPE" = 'Darwin' ]; then
        ${installScripts['macos']}
    fi
}

if [[ -z "$1" || "$1" = 'all' ]]; then
    run_all
    exit
fi

case "$1" in
    zsh|shell)  shift; ${installScripts['zsh']} ${@};;
    packages)   shift; ${installScripts['packages']} ${@};;
    golang)     shift; ${installScripts['golang']} ${@};;
    fonts)      shift; ${installScripts['fonts']} ${@};;
    git)        shift; ${installScripts['git']} ${@};;
    tmux)       shift; ${installScripts['tmux']} ${@};;
    emacs)      shift; ${installScripts['emacs']} ${@};;
    gpg)        shift; ${installScripts['gpg']} ${@};;
    vscode)     shift; ${installScripts['vscode']} ${@};;
    npm)        shift; ${installScripts['npm']} ${@};;
    mac)        shift; ${installScripts['macos']} ${@};;
    vim)        shift; ${installScripts['vim']} ${@};;
    docker)     shift; ${installScripts['docker']} ${@};;
esac
