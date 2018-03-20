#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Install Inconsolata font'
$ReloadFont = $false

$Library = "/usr/local/share/fonts"
if (Get-IsFedora) {
    $Library = "/usr/share/fonts"
} elseif ($IsMacOS) {
    $Library = "$HOME/Library/Fonts"
}

# Destination paths
$regular_font_out = "$Library/Inconsolata-Regular.ttf"
$bold_font_out = "$Library/Inconsolata-Bold.ttf"
$regular_font_powerline_out = "$Library/Inconsolata-Powerline-Regular.ttf"
$bold_font_powerline_out = "$Library/Inconsolata-Powerline-Bold.ttf"

# Source paths
$regular_font = "https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Regular.ttf"
$bold_font = "https://github.com/google/fonts/raw/master/ofl/inconsolata/Inconsolata-Bold.ttf"
$regular_font_powerline = "https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf"
$bold_font_powerline = "https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20Bold%20for%20Powerline.ttf"

function Install-Font ([string] $url, [string] $out) {
    if (!(Test-FileExists $out)) {
        sudo wget -q --show-progress -O $out $url
        if ($IsLinux) { $ReloadFont = $true }
    }
}

# If font doesn't exist, download to destination
Install-Font $regular_font $regular_font_out
Install-Font $bold_font $bold_font_out
Install-Font $regular_font_powerline $regular_font_powerline_out
Install-Font $bold_font_powerline $bold_font_powerline_out

# Linux, reload font cache
if ($ReloadFont) {
    fc-cache -f
}
