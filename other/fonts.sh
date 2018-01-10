#!/bin/bash
system_type="$(uname)"

echo "Install Inconsolata font"
RELOAD_FONT=0

library="/usr/local/share/fonts"
if [[ $system_type = "Darwin" ]]; then
    library="$HOME/Library/Fonts"
fi
regular_font_out="$library/Inconsolata-Regular.ttf"
bold_font_out="$library/Inconsolata-Bold.ttf"

regular_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"
bold_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"

if [ ! -f $regular_font_out ]; then
    sudo wget -O $regular_font_out $regular_font
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

if [ ! -f $bold_font_out ]; then
    sudo wget -O $bold_font_out $bold_font
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

if [ $RELOAD_FONT -eq 1 ]; then
    fc-cache -f
fi
