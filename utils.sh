export SYSTEM_TYPE="$(uname)"
export TMP_PATHS_DIR='./tmp-paths'
export DOTFILE_INSTALLER=1

LINUX_DISTRO=""
if [[ $SYSTEM_TYPE == "Linux" ]]; then
    LINUX_DISTRO="$(gawk -F= '/^NAME/{print $2}' /etc/os-release 2>/dev/null | tr -d '"')"
fi
export LINUX_DISTRO

mkdir -p "$TMP_PATHS_DIR"

addtopath() {
    module="$1"
    path="$2"
    pathfile="$TMP_PATHS_DIR/40-$module"

    echo "$path" >> $pathfile
}
export -f addtopath

add_zsh_hook() {
    hook="$1"
    hookname="$2"
    hookfile="$3"

    echo "Adding $hookname to ZSH $hook hooks"

    mkdir -p "$HOME/.local.zsh.d/$hook"
    ln -sfn "$hookfile" "$HOME/.local.zsh.d/$hook/$hookname.zsh"
}
export -f add_zsh_hook

rm_zsh_hook() {
    hook="$1"
    hookname="$2"
    hookpath="$HOME/.local.zsh.d/$hook/$hookname.zsh"

    echo "Removing $hookname from ZSH $hook hooks"

    [ -f "$hookpath" ] && rm -rf "$hookpath"
}
export -f rm_zsh_hook

zsh_hook_exists() {
    hook="$1"
    hookname="$2"
    hookpath="$HOME/.local.zsh.d/$hook/$hookname.zsh"

    [ -f "$hookpath" ]
    return $?
}
export -f zsh_hook_exists

finish() {
    file_count="$(ls -l $TMP_PATHS_DIR | wc -l)"
    if [ -d "$HOME/.local.zsh.d/paths" -a $file_count -gt 1 ]; then
        cp -r $TMP_PATHS_DIR/* "$HOME/.local.zsh.d/paths/"
    fi
    rm -rf "$TMP_PATHS_DIR"
}
trap finish EXIT

import_repo_key() {
    if [[ $LINUX_DISTRO == "Ubuntu" ]]; then
        curl -fsSL "$1" | sudo apt-key add -
    elif [[ $LINUX_DISTRO == "Fedora" ]]; then
        sudo rpm --import "$1"
    fi
}
export -f import_repo_key

install_repo_list() {
    CODE_RELEASE=''
    if [[ $SYSTEM_TYPE == "Linux" && $LINUX_DISTRO == "Ubuntu" ]]; then
        CODE_RELEASE=$(lsb_release -c | awk '{print $2}')
    fi

    REPO_FILE="$1"
    if [[ $LINUX_DISTRO == "Ubuntu" ]]; then
        REPO_FILE="${REPO_FILE}.list"
    elif [[ $LINUX_DISTRO == "Fedora" ]]; then
        REPO_FILE="${REPO_FILE}.repo"
    fi

    REPO_DIR='/etc/apt/sources.list.d'
    [[ $LINUX_DISTRO == "Fedora" ]] && REPO_DIR='/etc/yum.repos.d'

    sed "s/\$CODE_RELEASE/$CODE_RELEASE/" "$REPO_FILE" \
        | sudo tee $REPO_DIR/"$(basename $REPO_FILE)" >/dev/null
}
export -f install_repo_list

update_package_lists() {
    [[ $LINUX_DISTRO == "Ubuntu" ]] && sudo apt update
}
export -f update_package_lists

install_packages() {
    [[ $LINUX_DISTRO == "Ubuntu" ]] && sudo apt install -y ${@}
    [[ $LINUX_DISTRO == "Fedora" ]] && sudo dnf install -y ${@}
}
export -f install_packages

is_ubuntu() {
    [[ $LINUX_DISTRO == "Ubuntu" ]]
    return $?
}
export -f is_ubuntu

is_fedora() {
    [[ $LINUX_DISTRO == "Fedora" ]]
    return $?
}
export -f is_fedora

is_linux() {
    [[ $SYSTEM_TYPE == "Linux" ]]
    return $?
}
export -f is_linux

is_macos() {
    [[ $SYSTEM_TYPE == "Darwin" ]]
    return $?
}
export -f is_macos

cmd_exists() {
    which "$1" 2>/dev/null >/dev/null
    return $?
}
export -f cmd_exists
