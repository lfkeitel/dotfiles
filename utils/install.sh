# Depends: Nothing

decrypt_to_file() {
    local IN="$1"
    local OUT="$2"

    GPG_OUT="$(gpg2 --yes --output "$OUT" -d "$IN" 2>&1)"
    RET=$?
    [[ $RET != 0 ]] && echo "$GPG_OUT"
    return $RET
}
export -f decrypt_to_file

link_file() {
    ln -sfn "$1" "$2"
}
export -f link_file
