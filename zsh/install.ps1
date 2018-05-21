#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json')
)
Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Setting up ZSH'
Add-FileLink "$PSScriptRoot/.zshrc" "$HOME/.zshrc"
Add-FileLink "$PSScriptRoot/.zsh_aliases" "$HOME/.zsh_aliases"
Add-FileLink "$PSScriptRoot/.zsh_functions" "$HOME/.zsh_functions"

# If the folder exists, but the main script doesn't, remove everything to try again
if ((Test-DirExists "$HOME/.oh-my-zsh") -and -not (Test-FileExists "$HOME/.oh-my-zsh/oh-my-zsh.sh")) {
    Remove-Item "$HOME/.oh-my-zsh" -Recurse -Force | Out-Null
}

# oh-my-zsh
if (-not (Test-DirExists "$HOME/.oh-my-zsh")) {
    Write-Output "Installing oh-my-zsh"
    bash "$PSScriptRoot/install-oh-my-zsh.sh"

    # On Mac, set zsh as default
    if ($IsMacOS) {
        sudo dscl . -create "/Users/${env:USER}" UserShell /usr/local/bin/zsh
    }
}

$ZSHCustom = "$HOME/.oh-my-zsh/custom"

# Update Oh My ZSH
Push-Location "$HOME/.oh-my-zsh"
git pull --rebase --stat origin master
Pop-Location

# Install/update Plugins
function Install-ZSHPlugin ([string] $Plugin, [string] $Remote) {
    Write-Output "Installing plugin $Plugin"
    if (-not (Test-DirExists "$ZSHCustom/plugins/$Plugin")) {
        git clone $Remote "$ZSHCustom/plugins/$Plugin"
    }
    Push-Location "$ZSHCustom/plugins/$Plugin"
    git pull
    Pop-Location
}

$Settings.zsh.plugins | ForEach-Object {
    Install-ZSHPlugin $_.name $_.remote
}

New-Directory "$ZSHCustom/plugins/docker-host"
Add-FileLink "$PSScriptRoot/docker-host.sh" "$ZSHCustom/plugins/docker-host/docker-host.plugin.zsh"

# Theme
New-Directory "$ZSHCustom/themes"
Add-FileLink "$PSScriptRoot/lfk.zsh-theme" "$ZSHCustom/themes/lfk.zsh-theme"

# Setup hook system
New-Directory "$HOME/.local.zsh.d/pre"
New-Directory "$HOME/.local.zsh.d/post"
New-Directory "$HOME/.local.zsh.d/paths"

# Convert old custom into new hooks system
if (Test-FileExists "$HOME/.local.zsh") {
    mv -n "$HOME/.local.zsh" "$HOME/.local.zsh.d/post/00-old-local.zsh"
}

Add-ToPath 'zsh' "$HOME/bin"

# Add auto-complete scripts
New-Directory "$HOME/.zsh"
Add-FileLink "$PSScriptRoot/completion" "$HOME/.zsh/completion"

# Link up wd and project list plugins
$ProjectList = "$HOME/.project.list"
if (!(Test-FileExists $ProjectList)) {
    Write-Output $null > $ProjectList
}
Add-FileLink $ProjectList "$HOME/.warprc"

New-Directory "$HOME/code"

Add-ZshHook 'post' '10-vars' "$PSScriptRoot/vars.zsh"
