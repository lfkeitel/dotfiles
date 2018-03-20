#!/usr/bin/env pwsh
if (!$IsMacOS) { return }

# Setup Finder to show all files
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder /System/Library/CoreServices/Finder.app
