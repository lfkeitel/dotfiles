export PATH="$PATH:$HOME/.scripts:$HOME/bin"
export TERMINAL=st
export MPD_HOST="$HOME/.mpd/socket"
export XDG_CONFIG_HOME="$HOME/.config"

export BSPWM_WINDOW_1="Web"
export BSPWM_WINDOW_2="Terminal"
export BSPWM_WINDOW_3="Email"
export BSPWM_WINDOW_4="Editor"
export BSPWM_WINDOW_5="5"
export BSPWM_WINDOW_6="6"
export BSPWM_WINDOW_7="7"
export BSPWM_WINDOW_8="8"
export BSPWM_WINDOW_9="9"
export BSPWM_WINDOW_10="10"

google_drive_dir="$HOME/google-drive"

if [ -d $google_drive_dir ]; then
    mount | grep "$google_drive_dir" >/dev/null || /usr/sbin/google-drive-ocamlfuse "$google_drive_dir" &
fi
