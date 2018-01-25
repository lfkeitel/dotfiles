#!/usr/bin/env bash
system_type="$(uname)"


[[ $system_type != "Darwin" ]] && exit 0

# Setup Finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder /System/Library/CoreServices/Finder.app
