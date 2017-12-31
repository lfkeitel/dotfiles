#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"
tmux_config="$DIR/.tmux-$system_type.conf"

if [ -f "$tmux_config" ]; then
    echo "Setting up tmux"
    ln -sfn "$tmux_config" "$HOME/.tmux.conf"
fi
