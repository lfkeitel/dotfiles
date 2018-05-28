#!/bin/sh -e

# Take a screenshot
scrot /tmp/screen_locked.png

# Pixelate
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked2.png

# Delete raw screenshot
rm /tmp/screen_locked.png

# Lock the screen
i3lock -i /tmp/screen_locked2.png

# Turn of screen after a delay
sleep 60; pgrep i3lock && xset dpms force off
