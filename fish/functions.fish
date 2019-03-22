function fish_greeting
    list-todos 1
    echo
end

function list-todos -a level
    if test -z $level
        set level 1
    end

    if test -f "$HOME/todo"
        echo "P$level Todos:"
        set_color red
        grep --color=never -P "^P$level " "$HOME/todo" | sed -e "s/P$level //; s/^/  /"
    end

    set_color normal
end

function maclookup -a address
    # I don't call curl by itself because a normal response will not return a newline
    # but a failed response will. This removes any trailing whitespace and ensures
    # there's always a new line.
    echo (curl -s "https://api.macvendors.com/$address")
end

function sudossh -a host
    ssh -t $host sudo su
end

function sys-upgrade
    set linux_distro (gawk -F= '/^NAME/{print $2}' /etc/os-release 2>/dev/null | tr -d '"')
    if test $linux_distro = "Ubuntu"
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    else if test $linux_distro = "Fedora"
        sudo dnf upgrade -y
    else if test $linux_distro = "Arch Linux"
        yay
    else if test "(uname)" = "Darwin"
        brew upgrade
    end
end

function better_cat
    [ -d "$argv[1]" ] && ls -lah "$argv[1]" && return
    command cat $argv
end

function format_project_code -a num
    # If not number, return early
    if not string match --quiet --regex '\d+' $num
        echo '000'
        return
    end

    # Trim leading zeros
    set num (string trim -l -c '0' $num)
    [ -z $num ] && set num '0'

    # Pad number to three digits
    if [ $num -lt 10 ]
        echo "00$num"
    else if [ $num -lt 100 ]
        echo "0$num"
    else
        echo $num
    end
end

function code_jump -a project
    function echo_list
        echo -e (string join '\n' $argv)
    end

    # If arg is a number, cd to project
    if string match --quiet --regex '\d+' $project
        set project (format_project_code $project)
        cd $CODE_DIR/$project*
        return
    end

    set list ($FINDCMD $CODE_DIR -maxdepth 1 -printf "%f\n" | $GREPCMD -P '\d{3}\-' | sort)
    [ -n "$project" ] && set list (echo_list $list | $GREPCMD $project)

    set list_rows (count $list)
    set term_rows (stty size | cut -d' ' -f1)

    if [ -z (echo "$list" | tr -d "\n") ]
        echo "No matching projects found"
        return
    end

    if [ $list_rows -eq 1 ]
        cd $CODE_DIR/$list*
        return
    end

    if [ (expr $list_rows + 2) -gt $term_rows ]
        echo_list $list | less -e
    end
    echo_list $list

    echo
    read -P "Select a project or press enter: " project
    if string match --quiet --regex '\d+' $project
        set project (format_project_code $project)
        cd $CODE_DIR/$project*
    end
end

function project_jump
    cd "$argv[1]"
    if [ (count $argv) -gt 1 ]
        shift
        $argv
    end
end

function gen_project_aliases
    set alias_list ($FINDCMD $CODE_DIR -maxdepth 1 -type d -printf "%f\n" | $GREPCMD -P '\d{3}\-')
    for dir in $alias_list
        set code (echo "$dir" | cut -d- -f1)
        alias $code "project_jump $CODE_DIR/$dir"
    end
end
gen_project_aliases

function go_mod
    switch $argv[1]
        case on
            set -x GO111MODULE on
        case off
            set -x GO111MODULE off
        case '*'
            set -x GO111MODULE auto
    end
end

function activate -a VENV_NAME
    set VIRENV_ROOT "$HOME/code/venv"

    if [ -z "$VENV_NAME" ]
        echo "Available Virtual Environments:"
        $FINDCMD ~/code/venv -maxdepth 1 -type d  -printf " %f\n" | tail -n +2 | sort
        return
    end

    source $VIRENV_ROOT/$VENV_NAME/bin/activate.fish
end
alias act 'activate'

function _ssh_alias
    command ssh $argv
    tmux_color
end
alias ssh '_ssh_alias'

function _scp_alias
    command scp $argv
    tmux_color
end
alias scp '_scp_alias'

function autoenv_dis
    set AUTOENV_DISABLED 1
end

function autoenv_en
    set AUTOENV_DISABLED 0
end

function _docker_wrapper
    # Ensure tmux coloring is reset when using docker over SSH
    command docker $argv
    tmux_color
end
alias docker '_docker_wrapper'

function _please
    set last_cmd $history[1]
    read -n 1 -s -P "sudo $last_cmd >"
    eval "sudo $last_cmd"
end
alias please='_please'

function git_branch_sync -a branch
    git branch --set-upstream-to=origin/$branch $branch
end
alias gbs 'git_branch_sync'

function d
	while test $PWD != "/"
		if test -d .git
			break
		end
		cd ..
	end
end
