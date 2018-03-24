#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up Tmux'

Add-FileLink "$PSScriptRoot/.tmux.conf" "$HOME/.tmux.conf"
