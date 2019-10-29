#!/usr/bin/env python3
from os import makedirs
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import install_pkg, run_command, command_exists
import utils.platform as platform


def install_homebrew():
    if not platform.is_mac or command_exists("brew"):
        return

    print_line("Installing Homebrew")
    run_command(
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"',
        shell=True,
    )


def install_aur_helper():
    if not platform.is_arch or command_exists("yay"):
        return

    yay_path = Path.home().joinpath("code", "yay")

    if yay_path.is_dir():
        run_command("git fetch", cwd=yay_path)
    else:
        makedirs(yay_path.parent, exist_ok=True)
        run_command(
            "git clone 'https://aur.archlinux.org/yay-bin.git' " + str(yay_path)
        )

    run_command("makepkg -Acs", cwd=yay_path)
    run_command("sudo pacman -U *.pkg.tar", cwd=yay_path)


class Main(Installer):
    def run(self):
        print_header("Installing system packages")
        if platform.is_mac:
            self.install_mac_pkgs()
        else:
            self.install_linux_pkgs()

    def install_mac_pkgs(self):
        install_homebrew()
        install_pkg(*self.settings["packages"]["macos"])

    def install_linux_pkgs(self):
        if platform.is_fedora:
            install_pkg(
                *self.settings["packages"]["linux"],
                *self.settings["packages"]["fedora"]
            )
        elif platform.is_ubuntu:
            install_pkg(
                *self.settings["packages"]["linux"],
                *self.settings["packages"]["ubuntu"]
            )
        elif platform.is_arch:
            install_aur_helper()
            install_pkg(
                *self.settings["packages"]["linux"], *self.settings["packages"]["arch"]
            )

        run_command("sudo systemctl start haveged")
        run_command("sudo systemctl enable haveged")
