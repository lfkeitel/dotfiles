# Depends: Nothing

export SYSTEM_TYPE="$(uname)"
LINUX_DISTRO=""
if [[ $SYSTEM_TYPE == "Linux" ]]; then
    LINUX_DISTRO="$(gawk -F= '/^NAME/{print $2}' /etc/os-release 2>/dev/null | tr -d '"')"
fi
export LINUX_DISTRO

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
