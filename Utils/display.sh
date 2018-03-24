# Depends: Nothing

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
