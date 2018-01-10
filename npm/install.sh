#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sfn "$DIR/.npmrc" "$HOME/.npmrc"
