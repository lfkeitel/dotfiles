export NNN_USE_EDITOR=1
export NNN_COPIER="$SCRIPTS_DIR/nnn_copier.sh"
export NNN_BMS='d:~/Documents;c:~/code;D:~/Downloads/;k:~/Desktop'
export NNN_TMPFILE="/tmp/nnn"

n() {
    nnn "$@"

    if [ -f $NNN_TMPFILE ]; then
        . $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    fi
}
