#!/usr/bin/env pwsh
Param(
    [string]
    $SettingsFile = (Join-Path $PSScriptRoot 'settings.json'),

    [switch]
    $Force,

    [switch]
    $NoKey
)

Import-Module (Join-Path $PSScriptRoot '..' Utils)
$Settings = Get-JSONFile $SettingsFile

Write-Header 'Setting up GPG agent'

function Install-GPGPackages {
    if ($IsMacOS) {
        Install-SystemPackage gpg2 pidof pinentry-mac
    } elseif (Test-IsUbuntu) {
        Install-SystemPackage gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    } elseif (Test-IsFedora) {
        Install-SystemPackage ykpers libyubikey gnupg gnupg2-smime
    } elseif (Test-IsArch) {
        Install-SystemPackage gnupg pinentry ccid pcsclite
        sudo systemctl enable pcscd.service
        sudo systemctl start pcscd.service
    }
}

Add-ZshHook 'post' '10-gpg' "$PSScriptRoot/setuphook.zsh"
Add-FishHook 'post' '10-gpg' "$PSScriptRoot/setuphook.fish"

$InstalledFile = "$HOME/.gnupg/.dotfile-installed.3"

if ((Test-FileExists $InstalledFile) -and -not ($Force)) {
    Write-Output 'GPG already setup'
    return
}

if (!(Test-FileExists '/usr/local/bin/gpg2')) {
    sudo ln -s /usr/bin/gpg2 /usr/local/bin/gpg2 # Use macOS binary location for consistancy
}

Install-GPGPackages
New-Item "$HOME/.gnupg" -ItemType Directory -Force | Out-Null
Add-FileLink "$PSScriptRoot/gpg.conf" "$HOME/.gnupg/gpg.conf"

if ($IsMacOS) {
    Add-FileLink "$PSScriptRoot/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
} else {
    Remove-Item "$HOME/.gnupg/gpg-agent.conf" -Force -ErrorAction Ignore
}

chmod -R og-rwx "$HOME/.gnupg"

$gpgKey = $Settings.gpg.key
$gpgKeyNoSpaces = $gpgKey.replace(' ', '')

# Import my public key and trust it ultimately
if (!$NoKey) {
    gpg2 --recv-keys $gpgKeyNoSpaces
    $Key = (gpg2 --list-keys --fingerprint | Where-Object{ $_ -match $gpgKey }).Trim().Replace(' ', '')
    $Key = "${Key}:6:"
    Write-Output "$Key" | gpg2 --import-ownertrust
}

if ((Test-IsFedora) -and (Test-FileExists '/etc/xdg/autostart/gnome-keyring-ssh.desktop')) {
    sudo mv -f /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.inactive
}

# Idempotency
Remove-Item "$HOME/.gnupg/.dotfile-installed.*" -Force
touch $InstalledFile
