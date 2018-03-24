#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Vim'

New-Item "$HOME/.vim" -ItemType Directory -Force | Out-Null
Add-FileLink "$PSScriptRoot/.vimrc" "$HOME/.vimrc"

vim +PlugInstall +qall
