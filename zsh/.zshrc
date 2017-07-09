# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export WATER_TIME=1800

ZSH_THEME="gnzh"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git common-aliases zsh-autosuggestions command-not-found docker sudo wd vi-mode project)

# User configuration
export PATH="$HOME/bin:$HOME/go/bin:/usr/local/go/bin:$PATH"

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='emacs'
fi

# Go paths
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOSRC="$GOPATH/src"

# Start gpg-agent if it's not running
if ! pidof gpg-agent > /dev/null; then
    gpg-agent --homedir /home/lfkeitel/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
fi
source $HOME/.gnupg/env

# Force better docker commands
export DOCKER_HIDE_LEGACY_COMMANDS=1

# Import aliases
source $HOME/.zsh_aliases
