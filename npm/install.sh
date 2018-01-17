#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sfn "$DIR/.npmrc" "$HOME/.npmrc"

addtopath npm "$HOME/.npm-packages/bin"
