# To profile everything, add the code below to /etc/zshenv
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>$HOME/startlog.$$
    setopt xtrace prompt_subst
fi

setopt autopushd
# setopt globdots
export LANG=en_US.UTF-8
export EDITOR='nvim'
export CODE_DIR="$HOME/code"
export SCRIPTS_DIR="$HOME/.scripts"
CUSTOM_HOOKS_PATH="$HOME/.local.zsh.d"
CUSTOM_PATH_DIR="$CUSTOM_HOOKS_PATH/paths"
GREP_CMD=/bin/grep
AUTOENV_FILE_ENTER='.envrc'
AUTOENV_FILE_LEAVE='.envrc_leave'

export FINDCMD='find'
export GREPCMD='grep'
if [[ $(uname) = 'Darwin' ]]; then
    FINDCMD='gfind'
    GREPCMD='ggrep'
fi

run_custom_hooks() {
    setopt +o nomatch
    local hook="$1"
    if [ -d "$CUSTOM_HOOKS_PATH/$hook" ]; then
        for s in $CUSTOM_HOOKS_PATH/$hook/*.zsh(N); do
            source "$s"
        done
    fi
    setopt -o nomatch
}

addtopath() {
    if ! echo "$PATH" | "$GREPCMD" -Eq "(^|:)$1($|:)"; then
        if [ "$2" = "after" ]; then
            PATH="$PATH:$1"
        else
            PATH="$1:$PATH"
        fi
    fi
}

PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'

if [ -d "$CUSTOM_PATH_DIR" ]; then
    for s in $CUSTOM_PATH_DIR/*(N); do
        while read line; do
            addtopath $line
        done <$s
    done
fi

run_custom_hooks pre

run_custom_hooks pre-oh-my-zsh

# Bring in Oh My ZSH!
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="lfk"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git common-aliases zsh-autosuggestions docker sudo wd project docker-host you-should-use autoenv)
source $ZSH/oh-my-zsh.sh

run_custom_hooks post-oh-my-zsh

# Force better docker commands
export DOCKER_HIDE_LEGACY_COMMANDS=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
docker-host set_aliases

# Import extras
source $HOME/.zsh_functions
source $HOME/.zsh_aliases

# Setup auto-complete
fpath=("$HOME/.zsh/completion" $fpath)
autoload -Uz compinit && compinit -i

# Allow Ctrl-S in vim
stty -ixon

run_custom_hooks post

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
