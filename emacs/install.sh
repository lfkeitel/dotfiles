#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Emacs"
mkdir -p "$HOME/.emacs.d"
ln -sfn "$DIR/emacs/.emacs.d/config" "$HOME/.emacs.d/config"
ln -sfn "$DIR/emacs/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
ln -sfn "$DIR/emacs/.emacs.d/org-templates" "$HOME/.emacs.d/org-templates"
ln -sfn "$DIR/emacs/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

# Create org directory and index file
mkdir -p "$HOME/org"
touch "$HOME/org/index.org"
