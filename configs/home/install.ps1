#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' '..' Utils)

Write-Header 'Setting up tmux'
Add-FileLink "$PSScriptRoot/.tmux.conf" "$HOME/.tmux.conf"

Write-Header 'Setting up Git'
Add-FileLink "$PSScriptRoot/.gitconfig" "$HOME/.gitconfig"
Add-FileLink "$PSScriptRoot/.gitignore" "$HOME/.gitignore"
Add-FileLink "$PSScriptRoot/.gitmessage" "$HOME/.gitmessage"
