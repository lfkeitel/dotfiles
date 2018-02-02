# Depends: Nothing

export TMP_PATHS_DIR='./tmp-paths'
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
