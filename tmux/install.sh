#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux_config="$DIR/.tmux-new.conf"

install_header "Setting up Tmux"

# Ubuntu 16.04 is still old
if [ "$(tmux -V)" = "tmux 2.1" ]; then
    tmux_config="$DIR/.tmux-old.conf"
fi

if [ -f "$tmux_config" ]; then
    ln -sfn "$tmux_config" "$HOME/.tmux.conf"
fi
