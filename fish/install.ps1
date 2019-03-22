#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)
Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

$FishCfgDir = "$HOME/.config/fish"
$FishHooksDir = "$FishCfgDir/hooks"

Write-Header 'Setting up Fish'
Add-FileLink "$PSScriptRoot/config.fish" "$FishCfgDir/config.fish"
Add-FileLink "$PSScriptRoot/aliases.fish" "$FishCfgDir/aliases.fish"
Add-FileLink "$PSScriptRoot/functions.fish" "$FishCfgDir/functions.fish"

# Plugins
Add-FishFunction "docker-host" "$PSScriptRoot/docker-host.fish"

# Setup hook system
New-Directory "$FishHooksDir/pre"
New-Directory "$FishHooksDir/post"
New-Directory "$FishHooksDir/paths"

Add-ToPath 'local' "$HOME/bin"
Add-ToPath 'local' "$HOME/.scripts"
Add-ToPath 'local' "$HOME/.local/scripts"

New-Directory "$HOME/code"

Add-FishHook 'post' '10-vars' "$PSScriptRoot/vars.fish"
Add-FishHook 'post' '10-nnn-setup' "$PSScriptRoot/nnn-setup.fish"
Add-FishHook 'post' '10-git' "$PSScriptRoot/git.fish"
Add-FishHook 'pre' '10-theme' "$PSScriptRoot/theme.fish"

# chsh -s "$(which fish)"
