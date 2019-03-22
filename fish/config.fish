fish_vi_key_bindings
set -x LANG en_US.UTF-8
set -x EDITOR 'nvim'
set -x CODE_DIR "$HOME/code"
set -x SCRIPTS_DIR "$HOME/.scripts"
set CUSTOM_HOOKS_PATH "$HOME/.config/fish/hooks"
set CUSTOM_PATH_DIR "$CUSTOM_HOOKS_PATH/paths"
set CUSTOM_PLUGINS_DIR "$CUSTOM_HOOKS_PATH/plugins"
set AUTOENV_FILE_ENTER '.envrc'
set AUTOENV_FILE_LEAVE '.envrc_leave'

set -x FINDCMD 'find'
set -x GREPCMD 'grep'
if test (uname) = 'Darwin'
    set FINDCMD 'gfind'
    set GREPCMD 'ggrep'
end

function run_custom_hooks -a hook
    if [ -d "$CUSTOM_HOOKS_PATH/$hook" ]
        for s in $CUSTOM_HOOKS_PATH/$hook/*.fish
            source "$s"
        end
    end
end

function addtopath -a path_item pos
    if not contains $path_item $PATH
        if [ "$pos" = "after" ]; then
            set PATH $PATH $path_item
        else
            set PATH $path_item $PATH
        end
    end
end

set PATH '/usr/local/sbin' \
    '/usr/local/bin' \
    '/usr/sbin' \
    '/usr/bin' \
    '/sbin' \
    '/bin' \
    '/usr/games' \
    '/usr/local/games' \
    '/snap/bin'

if [ -d "$CUSTOM_PATH_DIR" ]
    for s in $CUSTOM_PATH_DIR/*
        while read line
            addtopath $line
        end <$s
    end
end

# Import extras
source "$HOME/.config/fish/functions.fish"
source "$HOME/.config/fish/aliases.fish"

run_custom_hooks pre

for s in $CUSTOM_PLUGINS_DIR/*.fish
    source "$s"
end

# Force better docker commands
set -x DOCKER_HIDE_LEGACY_COMMANDS 1
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
docker-host set_aliases

# Allow Ctrl-S in vim
if status is-interactive
    stty -ixon
end

if test -f /usr/share/autojump/autojump.fish;
	source /usr/share/autojump/autojump.fish;
end

run_custom_hooks post
