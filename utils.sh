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

decrypt_to_file() {
    IN="$1"
    OUT="$2"

    GPG_OUT="$(gpg2 --yes --output "$OUTPUT" -d "$DIR/servlist.conf.gpg" 2>&1)"
    RET=$?
    [[ $RET != 0 ]] && echo "$GPG_OUT"
    return $RET
}
export -f decrypt_to_file

show_banner() {
    show_multiline_banner "${@}"
}
export -f show_banner

install_header() {
    show_multiline_banner green "${@}"
}
export -f install_header

show_main_banner() {
    echo -n -e "\e[1m"
    show_multiline_banner main "${@}"
}
export -f show_main_banner

resolve_color_code() {
    case "$1" in
        red) echo -n "\e[31m";;
        black) echo -n "\e[30m";;
        green) echo -n "\e[32m";;
        yellow) echo -n "\e[33m";;
        blue) echo -n "\e[34m";;
        magenta) echo -n "\e[35m";;
        cyan) echo -n "\e[36m";;
        white) echo -n "\e[37m";;
    esac
}
export -f resolve_color_code

show_multiline_banner() {
    local MAIN=''
    [[ $1 == 'main' ]] && MAIN='yes' && shift

    local RESET_CODE="\e[0m"
    local COLOR_CODE="$(resolve_color_code $1)"
    if [[ -z $COLOR_CODE ]]; then
        COLOR_CODE=$RESET_CODE
    else
        shift
    fi

    local TOTAL_LINES=${#@}
    local MAX_LEN=0
    for var in "$@"; do
        local LEN=${#var}
        [[ $LEN > $MAX_LEN ]] && MAX_LEN=$LEN
    done

    print_fill_line() {
        echo -n '***'
        printf "*%.0s" $(seq 1 $MAX_LEN)
        echo '***'
    }

    print_main_fill_line() {
        local FILL="$1"
        echo -n '** '
        printf " %.0s" $(seq 1 $MAX_LEN)
        echo ' **'
    }

    echo -n -e $COLOR_CODE

    print_fill_line
    [[ -n $MAIN ]] && print_main_fill_line

    for i in $(seq 1 $TOTAL_LINES); do
        local LINE=${@:$i:1}
        local LINE_LEN=${#LINE}
        local PADDING=$(((($MAX_LEN - $LINE_LEN) / 2) + 1))
        local RPADDING=$PADDING

        if [[ $(($LINE_LEN % 2)) == 0 && $(($MAX_LEN % 2)) != 0 ]]; then
            RPADDING=$(($RPADDING+1))
        elif [[ $(($LINE_LEN % 2)) != 0 && $(($MAX_LEN % 2)) == 0 ]]; then
            RPADDING=$(($RPADDING+1))
        fi

        echo -n '**'
        printf ' %.0s' $(seq 1 $PADDING)
        echo -n $LINE
        printf ' %.0s' $(seq 1 $RPADDING)
        echo '**'
    done

    [[ -n $MAIN ]] && print_main_fill_line
    print_fill_line

    echo -e $RESET_CODE
}
export -f show_multiline_banner

show_colored_line() {
    local COLOR="$1"
    local RESET_CODE="\e[0m"
    local COLOR_CODE="$(resolve_color_code $1)"
    [[ -z $COLOR_CODE ]] && COLOR_CODE=$RESET_CODE

    echo -n -e "${COLOR_CODE}${2}${RESET_CODE}"
}
export -f show_colored_line

show_colored_line_nl() {
    show_colored_line "${@}"
    echo
}
export -f show_colored_line_nl

show_error_msg() {
    show_colored_line_nl red "${@}"
}
export -f show_error_msg

show_warning_msg() {
    show_colored_line_nl yellow "${@}"
}
export -f show_warning_msg

spinner() {
    local pid=$1
    local delay=0.75
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
export -f spinner

waiting_dots() {
    local pid=$1
    local delay=0.75
    local max_dots=${2:-5}
    local dots=0

    echo -n -e "\e[?25l" # Hide cursor

    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        echo -n '.'
        dots=$((dots+1))
        sleep $delay
        if [[ $dots == $max_dots ]]; then
            printf "\b%.0s" $(seq 1 $dots)
            printf " %.0s" $(seq 1 $dots)
            printf "\b%.0s" $(seq 1 $dots)
            dots=0
        fi
    done

    echo -n -e "\e[?25h" # Show cursor
}
export -f waiting_dots
