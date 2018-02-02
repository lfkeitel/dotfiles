#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_header "Setting up Tmux"

ln -sfn "$DIR/.tmux.conf" "$HOME/.tmux.conf"
