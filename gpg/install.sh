#!/usr/bin/env bash
[[ $DOTFILE_INSTALLER != 1 ]] && exit 0
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FORCE="$1"

install_gpg_packages() {
    if is_macos; then
        brew install gpg-agent gpg2 pidof
    elif is_ubuntu; then
        sudo apt install -y gnupg-agent gnupg2 pinentry-gtk2 scdaemon libccid pcscd libpcsclite1 gpgsm
    elif is_fedora; then
        sudo dnf install -y ykpers libyubikey gnupg gnupg2-smime pcsc-lite pcsc-lite-ccid
    fi
}

echo "Setting up GPG agent"
INSTALLED_FILE="$HOME/.gnupg/.dotfile-installed.3"

if [[ -f "$INSTALLED_FILE" && ! "$FORCE" = "force" ]]; then
    echo "GPG already setup"
    return
fi

if [[ ! -e /usr/local/bin/gpg2 ]]; then # Use macOS binary location for consistancy
    sudo ln -s /usr/bin/gpg2 /usr/local/bin/gpg2
fi

install_gpg_packages
mkdir -p "$HOME/.gnupg"
ln -sfn "$DIR/gpg.conf" "$HOME/.gnupg/gpg.conf"
if is_macos; then
    ln -sfn "$DIR/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
else
    # Until ran on all systems, this shouldn't have been copied or linked
    rm -f "$HOME/.gnupg/gpg-agent.conf"
fi
chmod -R og-rwx "$HOME/.gnupg"

# Import my public key and trust it ultimately
gpg2 --recv-keys E638625F
trust_str="$(gpg2 --list-keys --fingerprint | grep 'E638 625F' | tr -d '[:space:]' | cut -d'=' -f2 | awk '{ print $1 ":6:"}')"
echo "$trust_str" | gpg2 --import-ownertrust

if is_fedora; then
    sudo mv /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.inactive
fi

# Idempotency
rm -f $HOME/.gnupg/.dotfile-installed.*
touch "$INSTALLED_FILE"

add_zsh_hook 'post' '10-gpg' "$DIR/setuphook.zsh"
