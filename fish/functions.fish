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
    echo (curl -s -G "https://api.macvendors.com/$address" -H "Accept: text/plain" -H "Authorization: Bearer $MAC_VENDORS_TOKEN")
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
    if string match --quiet --regex '^\d{1,3}$' $project
        set project (format_project_code $project)
        cd $CODE_DIR/$project*
        return
    end

    set list ($FINDCMD $CODE_DIR -maxdepth 1 -printf "%f\n" | $GREPCMD -P '^\d{3}\-' | sort)

    if [ -n "$project" ]
        set project_lower (echo "$project" | tr '[[:upper:]]' '[[:lower:]]')

        # Compare project names as lowercase to wanted project name
        set list (echo_list $list | \
            awk "{ if (tolower(\$0) ~ /$project_lower/) print \$0 }")
    end

    set list_rows (count $list)
    set term_rows (stty size | cut -d' ' -f1)

    if [ $list_rows -eq 0 ]
        echo "No matching projects found"
        return
    else if [ $list_rows -eq 1 ]
        cd $CODE_DIR/$list*
        return
    end

    if [ (expr $list_rows + 2) -gt $term_rows ]
        echo_list $list | less -e
    end
    echo_list $list

    echo
    read -P "Select a project or press enter: " project
    if string match --quiet --regex '^\d{1,3}$' $project
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

    set -x VIRTUAL_ENV_DISABLE_PROMPT 't'
    source $VIRENV_ROOT/$VENV_NAME/bin/activate.fish
end
alias act 'activate'

function autoenv_dis
    set AUTOENV_DISABLED 1
end

function autoenv_en
    set AUTOENV_DISABLED 0
end

function _please
    set last_cmd $history[1]
    read -n 1 -s -P "sudo $last_cmd >"
    eval "sudo $last_cmd"
end
alias please='_please'

function d
	while test $PWD != "/"
		if test -d .git
			break
		end
		cd ..
	end
end

function c
    set code_path (which code 2>/dev/null)
    if test -n "$code_path"
        $code_path .
    end

    set code_path (which vscodium 2>/dev/null)
    if test -n "$code_path"
        $code_path .
    end
end

function pdfmerge
    set output $argv[1]
    set files $argv[2..(count $argv)]

    command gs -dBATCH \
        -sDEVICE=pdfwrite \
        -dCompatibilityLevel=1.4 \
        -dPDFSETTINGS=/default \
        -dNOPAUSE \
        -dQUIET \
        -dBATCH \
        -dAutoRotatePages=/None \
        -dDetectDuplicateImages \
        -dCompressFonts=true \
        -r150 \
        -sOutputFile=$output $files
end

function pdfmerge_nocompress
    set output $argv[1]
    set files $argv[2..(count $argv)]

    command gs -dBATCH \
        -sDEVICE=pdfwrite \
        -dPDFSETTINGS=/prepress \
        -dNOPAUSE \
        -dQUIET \
        -dBATCH \
        -sOutputFile=$output $files
end

function keycode
    xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
end

function good-morning
    set fullname (grep $USER /etc/passwd | cut -d':' -f5 | cut -d',' -f1)
    if [ -z "$fullname" ]
        set fullname $USER
    end
    echo "Good morning $fullname!"

    set local_morning_script "$HOME/.local/scripts/good-morning.sh"
    if test -f "$local_morning_script"
        $local_morning_script
    end

    echo -n 'Want to open a project?'
    read -P 'y/n ' response
    if [ "$response" = "y" ]
        code_jump
    end

    echo -n "Today is: "
    date '+%A %Y-%m-%d %H:%M'
end

if [ -n "(cp --help | grep 'progress bar')" ]
    function cp
        command cp -g $argv
    end
end

if [ -n "(mv --help | grep 'progress bar')" ]
    function mv
        command mv -g $argv
    end
end

function countdown
    set start (date +%s)
    set date1 (expr $start + $argv[1])
    while [ "$date1" -ge (date +%s) ]
        set timeleft (date -u --date @(expr $date1 - (date +%s)) +%H:%M:%S)
        echo -ne "$timeleft\r"
        sleep 0.1
    end
    echo

    set message 'Your countdown timer is complete.'
    if [ (count $argv) -ge 2 ]
        set message $argv[2..(count $argv)]
    end

    notify-send 'Timer is done!' "$message"
end

function stopwatch
    set start (date +%s)
    while true
        set newtime (date -u --date @(expr (date +%s) - $start) +%H:%M:%S)
        echo -ne "$newtime\r"
        sleep 0.1
    end
    echo
end

function git_commit_file_message -a use_previous
    set commit_template "$HOME/.gitmessage"

    # Define message file if not already
    if [ -z "$GIT_MESSAGE_FILE" ]
        set GIT_MESSAGE_FILE "$HOME/.gitcommitmessage"
    end

    # If not using previous message, overwrite with template or nothing
    if [ -z "$use_previous" ]
        if [ -f "$commit_template" ]
            cat "$commit_template" > "$GIT_MESSAGE_FILE"
        else
            cat /dev/null > "$GIT_MESSAGE_FILE"
        end
    end

    # Write message removing all comment lines
    vim $GIT_MESSAGE_FILE
    sed -i '/^#/d' $GIT_MESSAGE_FILE

    # If commit file is not empty, make a commit
    if [ -s "$GIT_MESSAGE_FILE" ]
        git commit -v -F $GIT_MESSAGE_FILE
    else
        echo "Empty commit message, commit aborted."
    end
end

function git_commit_all_file_message -a use_previous
    set commit_template "$HOME/.gitmessage"

    # Define message file if not already
    if [ -z "$GIT_MESSAGE_FILE" ]
        set GIT_MESSAGE_FILE "$HOME/.gitcommitmessage"
    end

    # If not using previous message, overwrite with template or nothing
    if [ -z "$use_previous" ]
        if [ -f "$commit_template" ]
            cat "$commit_template" > "$GIT_MESSAGE_FILE"
        else
            cat /dev/null > "$GIT_MESSAGE_FILE"
        end
    end

    # Write message removing all comment lines
    vim $GIT_MESSAGE_FILE
    sed -i '/^#/d' $GIT_MESSAGE_FILE

    # If commit file is not empty, make a commit
    if [ -s "$GIT_MESSAGE_FILE" ]
        git commit -a -v -F $GIT_MESSAGE_FILE
    else
        echo "Empty commit message, commit aborted."
    end
end

function qdig -a host
    dig $host +noall +answer
end

function vidmerge
    set input $argv[1]
    set output $argv[2]

    ffmpeg -i "$input.m4a" -i "$input.mp4" -c:v copy -c:a copy "$output.mp4"
end

function vidmergewebm
    set input1 $argv[1]
    set input2 $argv[2]
    set output $argv[3]

    ffmpeg -i "$input1" -i "$input2" -c:v libx264 -c:a aac "$output.mp4"
end

function quaycopy
    set image $argv[1]
    set category $argv[2]

    if test -n "$category"
        set category "$category/"
    end

    docker pull "$image"
    docker tag "$image" "quay.usi.edu/$category$image"
    docker push "quay.usi.edu/$category$image"
end

function dkh
    set line $argv[1]
    sed -i {$line}d ~/.ssh/known_hosts
end
