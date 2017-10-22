export LANG=en_US.UTF-8
export EDITOR='vim'

# Bring in Oh My ZSH!
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="lfk"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git common-aliases zsh-autosuggestions command-not-found docker sudo wd project docker-host)
source $ZSH/oh-my-zsh.sh

# Go paths
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOSRC="$GOPATH/src"

# Add custom folders to PATH
export PATH="$HOME/bin:$GOBIN:$GOROOT/bin:$PATH"

if [ "$(uname)" = "Darwin" ]; then
    export PATH="/usr/local/opt/gpg-agent/bin:$PATH" # gpg-agent
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" # VS Code
fi

# Start gpg-agent if it's not running
if ! pidof gpg-agent > /dev/null; then
    gpg-agent --homedir $HOME/.gnupg --daemon --sh --enable-ssh-support > $HOME/.gnupg/env
fi
source $HOME/.gnupg/env

if [ "$(uname)" = "Darwin" ]; then
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh"
fi

# Force better docker commands
export DOCKER_HIDE_LEGACY_COMMANDS=1

# Import aliases
source $HOME/.zsh_aliases
source $HOME/.zsh_functions
