#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
[[ is_linux ]] || exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install_header "Setting up Hexchat"

install_packages hexchat

decrypt_to_file "$DIR/servlist.conf.gpg" "$HOME/.config/hexchat/servlist.conf"
