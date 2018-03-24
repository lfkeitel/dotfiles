#!/usr/bin/env pwsh
Import-Module (Join-Path $PSScriptRoot '..' Utils)

Write-Header 'Setting up GPG agent'

$Force = ($Args.Count -gt 0 -and $Args[0] -eq 'force')

function Install-GPGPackages {
    if ($IsMacOS) {
        Install-SystemPackages gpg-agent gpg2 pidof
    } elseif (Get-IsUbuntu) {
        Install-SystemPackages gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    } elseif (Get-IsFedora) {
        Install-SystemPackages ykpers libyubikey gnupg gnupg2-smime pcsc-lite pcsc-lite-ccid
    }
}

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

# Import my public key and trust it ultimately
gpg2 --recv-keys E638625F
$Key = (gpg2 --list-keys --fingerprint | Where-Object{ $_ -match 'E638 625F' }).Trim().Replace(' ', '')
$Key = "${Key}:6:"
Write-Output "$Key" | gpg2 --import-ownertrust

if ((Get-IsFedora) -and (Test-FileExists '/etc/xdg/autostart/gnome-keyring-ssh.desktop')) {
    sudo mv -f /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.inactive
}

# Idempotency
Remove-Item "$HOME/.gnupg/.dotfile-installed.*" -Force
touch $InstalledFile

Add-ZshHook 'post' '10-gpg' "$PSScriptRoot/setuphook.zsh"
