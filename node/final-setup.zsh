#!/usr/bin/zsh

export NVM_DIR="$HOME/.nvm"
if [ "$(uname)" = "Darwin" ]; then
    source "/usr/local/opt/nvm/nvm.sh"
else
    source "$NVM_DIR/nvm.sh"
fi

install_node() {
    for version in "$@"; do
        nvm install --no-progress $version
    done
}

set_default() {
    nvm alias default $1
}

case $1 in
    install) shift; install_node $@;;
    default) set_default $2;;
esac
