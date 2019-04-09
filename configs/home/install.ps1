#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' '..' Utils)

Write-Header 'Setting up profile'
Add-FileLink "$PSScriptRoot/.profile" "$HOME/.profile"

Write-Header 'Setting up tmux'
Add-FileLink "$PSScriptRoot/.tmux.conf" "$HOME/.tmux.conf"

Write-Header 'Setting up makepkg'
Add-FileLink "$PSScriptRoot/.makepkg.conf" "$HOME/.makepkg.conf"

Write-Header 'Setting up Git'
Add-FileLink "$PSScriptRoot/.gitconfig" "$HOME/.gitconfig"
Add-FileLink "$PSScriptRoot/.gitignore" "$HOME/.gitignore"
Add-FileLink "$PSScriptRoot/.gitmessage" "$HOME/.gitmessage"

Write-Header 'Setting up ncmpcpp'
Add-FileLink "$PSScriptRoot/ncmpcpp/bindings" "$HOME/.ncmpcpp/bindings"
Add-FileLink "$PSScriptRoot/ncmpcpp/config" "$HOME/.ncmpcpp/config"

Write-Header 'Setting up Calcurse'
Add-FileLink "$PSScriptRoot/calcurse/conf" "$HOME/.calcurse/conf"
Add-FileLink "$PSScriptRoot/calcurse/keys" "$HOME/.calcurse/keys"
