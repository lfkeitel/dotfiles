#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up tmux"
ln -sfn "$DIR/.tmux.conf" "$HOME/.tmux.conf"
