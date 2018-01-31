#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Vim"
mkdir -p "$HOME/.vim"
ln -sfn "$DIR/.vimrc" "$HOME/.vimrc"

vim +PlugInstall +qall
