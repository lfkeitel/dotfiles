#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sfn "$DIR/.npmrc" "$HOME/.npmrc"

addtopath npm "$HOME/.npm-packages/bin"
