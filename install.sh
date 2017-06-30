#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Emacs
ln -sfn "$DIR/emacs/.emacs.d/config" "$HOME/.emacs.d/config"
ln -sfn "$DIR/emacs/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
ln -sfn "$DIR/emacs/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

# Git
ln -sfn "$DIR/git/.git*" "$HOME"

# ZSH
ln -sfn "$DIR/zsh/.zshrc" "$HOME"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My ZSH isn't installed. Make sure to do that."
fi
