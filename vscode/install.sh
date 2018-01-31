#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Setting up Visual Studio Code"
runInstall="no"
runLinks="no"
runExtInstall="no"

[[ -z "$1" || "$1" == "all" ]] && runInstall="yes" && runLinks="yes" && runExtInstall="yes"
[[ "$1" = "install" ]] && runInstall="yes"
[[ "$1" = "link" ]] && runLinks="yes"
[[ "$1" = "ext" ]] && runExtInstall="yes"

if is_macos; then
    addtopath vscode '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
fi

if ! cmd_exists code && [[ $runInstall = "yes" ]]; then
    if is_macos; then
        # TODO: Install VSCode: http://commandlinemac.blogspot.com/2008/12/installing-dmg-application-from-command.html
        echo "Please install VS Code first"
        exit 1
    elif is_linux; then
        import_repo_key https://packages.microsoft.com/keys/microsoft.asc
        install_repo_list $DIR/vscode
        update_package_lists
        install_packages code
    else
        echo 'Unsupported distribution'
        exit 0
    fi
fi

if [[ $runLinks = "yes" ]]; then
    settingsPath="$HOME/.config/Code/User"
    if is_macos; then
        settingsPath="$HOME/Library/Application Support/Code/User"
    fi

    mkdir -p "$settingsPath"
    ln -sfn "$DIR/settings.json" "$settingsPath/settings.json"
    ln -sfn "$DIR/keybindings.json" "$settingsPath/keybindings.json"

    if [[ -e "$settingsPath/snippets" ]]; then
        rm -rf "$settingsPath/snippets"
    fi
    ln -sfn "$DIR/snippets" "$settingsPath"
fi

if [[ $runExtInstall = "yes" ]]; then
    while read ext; do
        code --install-extension "$ext"
    done <$DIR/extensions
fi
