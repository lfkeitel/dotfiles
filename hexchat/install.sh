#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
[[ is_linux ]] || exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_header "Setting up Hexchat"

if ! is_pkg_installed hexchat; then
    install_packages hexchat
fi

link_file() {
    ln -sfn "$DIR/$1.conf" "$HOME/.config/hexchat/$1.conf"
}

decrypt_to_file "$DIR/servlist.conf.gpg" "$HOME/.config/hexchat/servlist.conf"
link_file chanopt
link_file colors
link_file hexchat
link_file ignore
link_file notify
link_file sound
