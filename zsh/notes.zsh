NOTES_DIR="${NOTES_DIR:-$HOME/.notes}"

_make_notes_dir() {
    if [[ ! -d $NOTES_DIR ]]; then
        mkdir -p "$NOTES_DIR"
    fi
}

n() {
    _make_notes_dir
    $EDITOR "$NOTES_DIR/$*".note
}

nls() {
    _make_notes_dir

    echo "Notes:"
    ls -c "$NOTES_DIR" | grep "$*" | awk '{print "- "$1}'
}

_n_complete() {
    ENTRIES="$(ls -c "$NOTES_DIR" | grep "$PREFIX")" # grep directory list for matches
    while IFS= read -r ENTRY; do
        compadd "$(echo $ENTRY | rev | cut -f 2- -d '.' | rev)" # strip extension and add to completion
    done <<< "$ENTRIES"
}
compdef _n_complete n

alias notes='n'
alias lsnotes='nls'
