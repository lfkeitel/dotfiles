#!/usr/bin/zsh

source $HOME/.nvm/nvm.sh

install_node() {
    for version in "$@"; do
        nvm install $version
    done
}

set_default() {
    nvm alias default $1
}

case $1 in
    install) shift; install_node $@;;
    default) set_default $2;;
esac
