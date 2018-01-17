#!/usr/bin/env bash
system_type="$(uname)"


if [[ $system_type != "Darwin" ]]; then exit 0; fi

# Setup Finder
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder /System/Library/CoreServices/Finder.app
