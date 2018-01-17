#!/usr/bin/env bash
system_type="$(uname)"

echo "Install Inconsolata font"
RELOAD_FONT=0

library="/usr/local/share/fonts"
if [[ $system_type = "Darwin" ]]; then
    library="$HOME/Library/Fonts"
fi

# Destination paths
regular_font_out="$library/Inconsolata-Regular.ttf"
bold_font_out="$library/Inconsolata-Bold.ttf"
regular_font_powerline_out="$library/Inconsolata-Powerline-Regular.ttf"
bold_font_powerline_out="$library/Inconsolata-Powerline-Bold.ttf"

# Source paths
regular_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"
bold_font="https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"
regular_font_powerline="https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf"
bold_font_powerline="https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20Bold%20for%20Powerline.ttf"

# If font doesn't exist, download to destination
if [ ! -f $regular_font_out ]; then
    sudo wget -q --show-progress -O $regular_font_out $regular_font
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

if [ ! -f $bold_font_out ]; then
    sudo wget -q --show-progress -O $bold_font_out $bold_font
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

if [ ! -f $regular_font_powerline_out ]; then
    sudo wget -q --show-progress -O $regular_font_powerline_out $regular_font_powerline
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

if [ ! -f $bold_font_powerline_out ]; then
    sudo wget -q --show-progress -O $bold_font_powerline_out $bold_font_powerline
    if [[ $system_type != "Darwin" ]]; then RELOAD_FONT=1; fi
fi

# Linux, reload font cache
if [ $RELOAD_FONT -eq 1 ]; then
    fc-cache -f
fi
