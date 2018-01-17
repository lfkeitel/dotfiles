#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
system_type="$(uname)"

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

echo "Setting up ZSH"
ln -sfn "$DIR/.zshrc" "$HOME/.zshrc"
ln -sfn "$DIR/.zsh_aliases" "$HOME/.zsh_aliases"
ln -sfn "$DIR/.zsh_functions" "$HOME/.zsh_functions"

# oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh"
    "$DIR/install-oh-my-zsh.sh"

    # On Mac, set zsh as default
    if [ "$system_type" = "Darwin" ]; then
        sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
    fi
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-"$HOME/.oh-my-zsh/custom"}"

# Update Oh My ZSH
pushd "$HOME/.oh-my-zsh"
git pull
popd

# Install/update Plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
pushd "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git pull
popd

if [ ! -d "$ZSH_CUSTOM/plugins/project" ]; then
    git clone https://github.com/lfkeitel/project-list.git "$ZSH_CUSTOM/plugins/project"
fi
pushd "$ZSH_CUSTOM/plugins/project"
git pull
popd

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
