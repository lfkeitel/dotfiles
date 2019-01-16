set -x NNN_USE_EDITOR 1
set -x NNN_COPIER "$SCRIPTS_DIR/nnn_copier.sh"
set -x NNN_BMS 'd:~/Documents;c:~/code;D:~/Downloads/;k:~/Desktop'
set -x NNN_TMPFILE "/tmp/nnn"

function n
    nnn $argv

    if [ -f $NNN_TMPFILE ]
        source $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    end
end
