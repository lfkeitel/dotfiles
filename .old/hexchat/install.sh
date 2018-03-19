#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
[[ is_linux ]] || exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_header "Setting up Hexchat"

if ! is_pkg_installed hexchat; then
    install_packages hexchat
fi

install_hex_file() {
    cp -u -f "$DIR/$1.conf" "$HOME/.config/hexchat/$1.conf"
}

decrypt_to_file "$DIR/servlist.conf.gpg" "$HOME/.config/hexchat/servlist.conf"
install_hex_file chanopt
install_hex_file colors
install_hex_file hexchat
install_hex_file ignore
install_hex_file notify
install_hex_file sound
