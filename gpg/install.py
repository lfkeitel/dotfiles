#!/usr/bin/env python3
from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import install_pkg, run_command, run_command_no_out
from utils.utils import link_file, settings, file_exists, remove
import utils.platform as platform
from utils.shell import Hook, add_fish_hook, add_zsh_hook


SCRIPT_DIR = Path(__file__).parent
HOME_DIR = Path.home()
GNUPG_DIR = HOME_DIR.joinpath(".gnupg")
INSTALLED_CANARY = GNUPG_DIR.joinpath(".dotfile-installed.4")


class Main(Installer):
    def run(self):
        print_header("Setting up GPG")

        add_zsh_hook(Hook.POST, "10-gpg", SCRIPT_DIR.joinpath("setuphook.zsh"))
        add_fish_hook(Hook.POST, "10-gpg", SCRIPT_DIR.joinpath("setuphook.fish"))

        if file_exists(INSTALLED_CANARY) and "force" not in self.args:
            print_line("GPG already setup")
            return

        # Use macOS binary location for consistancy
        if not file_exists("/usr/local/bin/gpg2"):
            link_file("/usr/bin/gpg2", "/usr/local/bin/gpg2", sudo=True)

        self.install_pkgs()

        os.makedirs(GNUPG_DIR, exist_ok=True)
        link_file(SCRIPT_DIR.joinpath("gpg.conf"), GNUPG_DIR.joinpath("gpg.conf"))

        if platform.is_mac:
            link_file(
                SCRIPT_DIR.joinpath("gpg-agent.conf"),
                GNUPG_DIR.joinpath("gpg-agent.conf"),
            )
        else:
            remove(GNUPG_DIR.joinpath("gpg-agent.conf"))

        run_command_no_out(f"chmod -R og-rwx {str(GNUPG_DIR)}")

        gpg_key = settings["gpg"]["key"]
        print_line(f"GPG Key: {gpg_key}")

        # Import my public key and trust it ultimately
        if "nokey" not in self.args:
            run_command(f"gpg2 --recv-keys {gpg_key}")
            trust_key = f"{gpg_key}:6:"
            run_command(f"echo '{trust_key}' | gpg2 --import-ownertrust", shell=True)

        if platform.is_fedora and file_exists(
            "/etc/xdg/autostart/gnome-keyring-ssh.desktop"
        ):
            run_command(
                "sudo mv -f /etc/xdg/autostart/gnome-keyring-ssh.desktop /etc/xdg/autostart/gnome-keyring-ssh.desktop.inactive"
            )

        # Idempotency
        run_command('rm -f "$HOME/.gnupg/.dotfile-installed.*"', shell=True)
        run_command(f"touch {str(INSTALLED_CANARY)}")

    def install_pkgs(self):
        if platform.is_mac:
            install_pkg("gpg2", "pidof", "pinentry-mac")
        elif platform.is_ubuntu:
            install_pkg(
                "gnupg-agent",
                "gnupg2",
                "pinentry-gtk2",
                "scdaemon",
                "libccid",
                "pcscd",
                "libpcsclite1",
                "gpgsm",
            )
        elif platform.is_fedora:
            install_pkg("ykpers", "libyubikey", "gnupg", "gnupg2-smime")
        elif platform.is_arch:
            install_pkg("gnupg", "pinentry", "ccid", "pcsclite")
            run_command("sudo systemctl enable pcscd.service")
            run_command("sudo systemctl start pcscd.service")
        else:
            print_line("Unsupported distribution")
