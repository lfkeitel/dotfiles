#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Install Rust'

if (Get-CommandExists 'rustup') {
    Write-ColoredLine "Rustup is already installed, try running 'rustup update'" DarkGreen
    return
}

$RustupInitURL = "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"
if ($IsMacOS) {
    $RustupInitURL = "https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init"
}

$DownloadedFile = (mktemp)

Get-RemoteFile $RustupInitURL $DownloadedFile

& $DownloadedFile --no-modify-path -y