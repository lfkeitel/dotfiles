# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export WATER_TIME=1800

ZSH_THEME="gnzh"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git common-aliases gpg-agent zsh-autosuggestions command-not-found docker sudo wd vi-mode)

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

alias gpg='gpg2'

# Go paths
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOSRC="$GOPATH/src"

alias fix-mounts='sudo umount -a -t cifs -l -f'
SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh
export SSH_AUTH_SOCK

alias digrep="docker image ls | grep"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export DOCKER_HIDE_LEGACY_COMMANDS=1

alias pwdu='du --max-depth=1 -h .'
