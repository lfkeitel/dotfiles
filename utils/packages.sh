# Depends: system

import_repo_key() {
    if is_ubuntu; then
        curl -fsSL "$1" | sudo apt-key add -
    elif is_fedora; then
        sudo rpm --import "$1"
    fi
}
export -f import_repo_key

install_repo_list() {
    CODE_RELEASE=''
    is_ubuntu && CODE_RELEASE=$(lsb_release -c | awk '{print $2}')

    REPO_FILE="$1.list"
    is_fedora && REPO_FILE="$1.repo"

    REPO_DIR='/etc/apt/sources.list.d'
    is_fedora && REPO_DIR='/etc/yum.repos.d'

    sed "s/\$CODE_RELEASE/$CODE_RELEASE/" "$REPO_FILE" \
        | sudo tee $REPO_DIR/"$(basename $REPO_FILE)" >/dev/null
}
export -f install_repo_list

update_package_lists() {
    is_ubuntu && sudo apt update
}
export -f update_package_lists

install_packages() {
    is_ubuntu && sudo apt install -y ${@}
    is_fedora && sudo dnf install -y ${@}
}
export -f install_packages

is_pkg_installed() {
    if is_ubuntu; then
        COUNT=$(apt list $1 2>/dev/null | grep installed | wc -l)
        [[ $COUNT > 0 ]]
        return $?
    elif is_fedora; then
        dnf list $1
        return $?
    elif is_macos; then
        [[ -z "$(brew list $1 2>/dev/null)" ]]
        return $?
    fi
}
export -f is_pkg_installed

cmd_exists() {
    which "$1" 2>/dev/null >/dev/null
    return $?
}
export -f cmd_exists
