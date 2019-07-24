set -xg NNN_USE_EDITOR 1
set -xg NNN_COPIER "$SCRIPTS_DIR/nnn_copier.sh"
set -xg NNN_BMS 'd:~/Documents;c:~/code;D:~/Downloads/;k:~/Desktop'
set -xg NNN_TMPFILE "/tmp/nnn"

function n
    nnn $argv

    if [ -f $NNN_TMPFILE ]
        source $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    end
end
