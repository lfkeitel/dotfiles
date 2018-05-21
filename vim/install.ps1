#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Vim'

sudo pip3 install neovim

New-Item "$HOME/.vim" -ItemType Directory -Force | Out-Null
Add-FileLink "$PSScriptRoot/.vimrc" "$HOME/.vimrc"

# Install Plug for plugin management
$remote = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
$local = "$HOME/.vim/autoload/plug.vim"
New-Directory "$HOME/.vim/autoload"
Get-RemoteFile $remote $local

vim +PlugInstall +qall
