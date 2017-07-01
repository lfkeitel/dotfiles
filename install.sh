#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Install applications
sudo apt install vim emacs curl zsh

# Emacs
ln -sfn "$DIR/emacs/.emacs.d/config" "$HOME/.emacs.d/config"
ln -sfn "$DIR/emacs/.emacs.d/lisp" "$HOME/.emacs.d/lisp"
ln -sfn "$DIR/emacs/.emacs.d/init.el" "$HOME/.emacs.d/init.el"

# Git
ln -sfn "$DIR/git/.git*" "$HOME"

# ZSH
ln -sfn "$DIR/zsh/.zshrc" "$HOME"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
