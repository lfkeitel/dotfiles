set -xg NNN_USE_EDITOR 1
set -xg NNN_COPIER "$SCRIPTS_DIR/nnn_copier.sh"
set -xg NNN_BMS 'h:~;d:~/Documents;c:~/code;D:~/Downloads/;k:~/Desktop'
set -xg NNN_TMPFILE "/tmp/nnn"
set BLK "0B"
set CHR "0B"
set DIR "04"
set EXE "06"
set REG "00"
set HARDLINK "06"
set SYMLINK "06"
set MISSING "00"
set ORPHAN "09"
set FIFO "06"
set SOCK "0B"
set OTHER "06"
set -xg NNN_FCOLORS 'c1e2272e006033f7c6d6abc4'
set -xg NNN_COLORS '#0a1b2c3d;1234'

function n
    nnn $argv

    if [ -f $NNN_TMPFILE ]
        source $NNN_TMPFILE
        rm -f $NNN_TMPFILE
    end
end
