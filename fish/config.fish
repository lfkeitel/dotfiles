set -x LANG en_US.UTF-8
set -x EDITOR 'nvim'
set -x CODE_DIR "$HOME/code"
set -x USERID (id -u)
set -x SCRIPTS_DIR "$HOME/.scripts"
set -x AWS_DEFAULT_PROFILE main
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

addtopath '/usr/local/sbin'
addtopath '/usr/local/bin'
addtopath '/usr/sbin'
addtopath '/usr/bin'
addtopath '/sbin'
addtopath '/bin'
addtopath '/usr/games'
addtopath '/usr/local/games'
addtopath '/snap/bin'

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

if [ -f /usr/share/autojump/autojump.fish ]
	source /usr/share/autojump/autojump.fish;
end

if [ -d /run/user/$USERID/i3 ]
    set -x I3SOCK (command ls /run/user/$USERID/i3/ipc-socket.*)
end

run_custom_hooks post
