#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Vim'

# Install NeoVim
if (!(Get-CommandExists 'nvim')) {
    if (Get-IsFedora) {
        Install-SystemPackages python2-neovim python3-neovim
    } elseif (Get-IsUbuntu) {
        Install-UbuntuPPA 'neovim-ppa/stable' -Update
        Install-SystemPackages neovim python-dev python-pip python3-dev python3-pip
        sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
        sudo update-alternatives --config vi
        sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
        sudo update-alternatives --config vim
        sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
        sudo update-alternatives --config editor
    }
}

if (!(Get-PipPackInstalled neovim)) {
    sudo pip3 install neovim
}

New-Directory "$HOME/.config/nvim"
Add-FileLink "$PSScriptRoot/.vimrc" "$HOME/.config/nvim/init.vim"

# Install Vim-Plug for plugin management
$Remote = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
$Local = "$HOME/.local/share/nvim/site/autoload"
New-Directory $Local
Get-RemoteFile $Remote "$Local/plug.vim"

# Launch NeoVim to install plugins
nvim +PlugInstall +qall
