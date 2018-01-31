#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_header "Setting up Git"
ln -sfn "$DIR/.gitconfig" "$HOME/.gitconfig"
ln -sfn "$DIR/.gitignore" "$HOME/.gitignore"
ln -sfn "$DIR/.gitmessage" "$HOME/.gitmessage"
