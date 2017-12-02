#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"

echo "Setting up Visual Studio Code"
runInstall="no"
runLinks="no"
runExtInstall="no"

[[ -z "$1" ]] && runInstall="yes" $$ runLinks="yes" && runExtInstall="yes"
[[ "$1" = "all" || "$1" = "install" ]] && runInstall="yes"
[[ "$1" = "all" || "$1" = "link" ]] && runLinks="yes"
[[ "$1" = "all" || "$1" = "ext" ]] && runExtInstall="yes"

if [[ $runInstall = "yes" && -z "$(which code 2>/dev/null)" ]]; then
    if [[ $system_type = "Darwin" ]]; then
        # TODO: Install VSCode: http://commandlinemac.blogspot.com/2008/12/installing-dmg-application-from-command.html
        echo "Please install VS Code first"
        exit 1
    else
        wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
        sudo dpkg -i vscode.deb
        sudo apt install -f
        rm vscode.deb
    fi
fi

if [[ $runLinks = "yes" ]]; then
    settingsPath="$HOME/.config/Code/User"
    if [ "$system_type" = "Darwin" ]; then
        settingsPath="$HOME/Library/Application Support/Code/User"
    fi

    ln -sfn "$DIR/settings.json" "$settingsPath/settings.json"
    ln -sfn "$DIR/keybindings.json" "$settingsPath/keybindings.json"

    if [[ -e "$settingsPath/snippets" ]]; then
        rm -rf "$settingsPath/snippets"
    fi
    ln -sfn "$DIR/snippets" "$settingsPath"
fi

# Install extensions
vscode_exts=(
    bungcip.better-toml
    ms-vscode.cpptools
    ms-vscode.csharp
    akamud.vscode-caniuse
    wesbos.theme-cobalt2
    naumovs.color-highlight
    anseki.vscode-color
    msjsdiag.debugger-for-chrome
    PeterJausovec.vscode-docker
    EditorConfig.editorconfig
    dbaeumer.vscode-eslint
    donjayamanne.githistory
    eamodio.gitlens
    felipecaputo.git-project-manager
    HookyQR.githubissues
    lukehoban.go
    casualjim.gotemplate
    oderwat.indent-rainbow
    wholroyd.jinja
    redhat.java
    Ionide.ionide-fsharp
    lfkeitel.language-nitrogen
    techer.open-in-browser
    christian-kohler.path-intellisense
    felixfbecker.php-intellisense
    alefragnani.project-manager
    ms-python.python
    2gua.rainbow-brackets
    kalitaalexey.vscode-rust
    swyphcosmo.spellchecker
    rashwell.tcl
    eg2.tslint
    robertohuertasm.vscode-icons
    MattiasPernhult.vscode-todo
    jsynowiec.vscode-insertdatestring
    bibhasdn.unique-lines
    formulahendry.auto-close-tag
    sysoev.language-stylus
    formulahendry.auto-rename-tag
    webfreak.code-d
)

if [[ $runExtInstall = "yes" ]]; then
    for ext in "${vscode_exts[@]}"; do
        code --install-extension "$ext"
    done
fi
