#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
[[ $SYSTEM_TYPE != "Darwin" ]] && exit 0

# Setup Finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder /System/Library/CoreServices/Finder.app
