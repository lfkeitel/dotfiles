#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

is_linux || return
if cmd_exists docker && [[ "$1" != 'force' ]]; then
    echo "Docker already installed, skipping"
    return
fi

import_repo_key https://download.docker.com/linux/ubuntu/gpg
install_repo_list $DIR/docker
update_package_lists
install_packages docker-ce
