#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

install_header "Setting up ZSH"
ln -sfn "$DIR/.zshrc" "$HOME/.zshrc"
ln -sfn "$DIR/.zsh_aliases" "$HOME/.zsh_aliases"
ln -sfn "$DIR/.zsh_functions" "$HOME/.zsh_functions"

# If the folder exists, but the main script doesn't, remove everything to try again
if [ -d "$HOME/.oh-my-zsh" -a ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
fi

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    "$DIR/install-oh-my-zsh.sh"

    # On Mac, set zsh as default
    if is_macos; then
        sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
    fi
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}"

# Update Oh My ZSH
pushd "$HOME/.oh-my-zsh"
git pull --rebase --stat origin master
popd

# Install/update Plugins
install_zsh_plugin() {
    local plugin_name="$1"
    local remote_url="$2"

    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin_name" ]; then
        git clone $remote_url "$ZSH_CUSTOM/plugins/$plugin_name"
    fi
    pushd "$ZSH_CUSTOM/plugins/$plugin_name"
    git pull
    popd
}

install_zsh_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions.git
install_zsh_plugin project https://github.com/lfkeitel/project-list.git

mkdir -p "$ZSH_CUSTOM/plugins/docker-host"
ln -sfn "$DIR/docker-host.sh" "$ZSH_CUSTOM/plugins/docker-host/docker-host.plugin.zsh"

# Theme
mkdir -p "$ZSH_CUSTOM/themes"
if [ -h "$ZSH_CUSTOM/themes/gnzh.zsh-theme" ]; then # Remove this if once all machines have been updated
    rm "$ZSH_CUSTOM/themes/gnzh.zsh-theme"
fi
ln -sfn "$DIR/lfk.zsh-theme" "$ZSH_CUSTOM/themes/lfk.zsh-theme"

# Setup hook system
mkdir -p "$HOME/.local.zsh.d/pre"
mkdir -p "$HOME/.local.zsh.d/post"
mkdir -p "$HOME/.local.zsh.d/paths"

# Convert old custom into new hooks system
if [ -f "$HOME/.local.zsh" ]; then
    mv -n "$HOME/.local.zsh" "$HOME/.local.zsh.d/post/00-old-local.zsh"
fi

addtopath 'zsh' "$HOME/bin"

# Add auto-complete scripts
mkdir -p "$HOME/.zsh"
link_file "$DIR/completion" "$HOME/.zsh/completion"
