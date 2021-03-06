#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

copy_hexchat_config() {
    cp -a -f -u $HOME/.config/hexchat/$1.conf $DIR/$1.conf
}

copy_hexchat_config_encrypted() {
    gpg --encrypt -r lee@keitel.xyz --armour -o $DIR/$1.conf.gpg $HOME/.config/hexchat/$1.conf
}

copy_hexchat_config chanopt
copy_hexchat_config colors
copy_hexchat_config hexchat
copy_hexchat_config ignore
copy_hexchat_config notify
copy_hexchat_config sound
copy_hexchat_config_encrypted servlist
