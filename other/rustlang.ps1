#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile
$CargoBin = "$HOME/.cargo/bin"

Write-Header 'Install Rust'

if (Test-CommandExists 'rustup') {
    rustup update stable
} else {
    $RustupInitURL = "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"
    if ($IsMacOS) {
        $RustupInitURL = "https://static.rust-lang.org/rustup/dist/x86_64-apple-darwin/rustup-init"
    }

    $DownloadDir = (mktemp -d)
    $DownloadFile = "$DownloadDir/rustup-init"

    wget -q --show-progress -O $DownloadFile $RustupInitURL

    chmod +x $DownloadFile
    & $DownloadFile --no-modify-path -y

    Remove-Item $DownloadDir -Force -Recurse
}

if ($Settings.rust.nightly) {
    & "$CargoBin/rustup" install nightly
}

& "$CargoBin/rustup" component add $Settings.rust.components

Add-ToPath rust $CargoBin
