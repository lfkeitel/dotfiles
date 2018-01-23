setopt autopushd
export LANG=en_US.UTF-8
export EDITOR='vim'
CUSTOM_HOOKS_PATH="$HOME/.local.zsh.d"
CUSTOM_PATH_DIR="$CUSTOM_HOOKS_PATH/paths"
GREP_CMD=/bin/grep

if [ "$(uname)" = "Darwin" ]; then
    GREP_CMD="$(whereis grep)"
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
    if ! echo "$PATH" | "$GREP_CMD" -Eq "(^|:)$1($|:)"; then
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
plugins=(git common-aliases zsh-autosuggestions command-not-found docker sudo wd project docker-host)
source $ZSH/oh-my-zsh.sh

run_custom_hooks post-oh-my-zsh

# Force better docker commands
export DOCKER_HIDE_LEGACY_COMMANDS=1

export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Import extras
source $HOME/.zsh_aliases
source $HOME/.zsh_functions

run_custom_hooks post

if [ -f "$HOME/.tnsrc" ]; then
    source "$HOME/.tnsrc"
fi
