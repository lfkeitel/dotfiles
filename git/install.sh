#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Git"
ln -sfn "$DIR/.gitconfig" "$HOME/.gitconfig"
ln -sfn "$DIR/.gitignore" "$HOME/.gitignore"
ln -sfn "$DIR/.gitmessage" "$HOME/.gitmessage"
