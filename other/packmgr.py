#!/usr/bin/env python3
from os import makedirs
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import install_pkg, run_command, command_exists
import utils.platform as platform


def install_homebrew(force=False):
    if not platform.is_mac or (not force and command_exists("brew")):
        return

    print_line("Installing Homebrew")
    run_command(
        '/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"',
        shell=True,
    )


def install_aur_helper(force=False):
    if not platform.is_arch or (not force and command_exists("yay")):
        return

    yay_path = Path.home().joinpath("code", "yay")

    if yay_path.is_dir():
        run_command("git fetch", cwd=yay_path)
    else:
        makedirs(yay_path.parent, exist_ok=True)
        run_command(f"git clone 'https://aur.archlinux.org/yay-bin.git' {yay_path}")

    run_command("makepkg -Acs", cwd=yay_path)
    run_command("sudo pacman -U *.pkg.tar", cwd=yay_path, shell=True)


class Main(Installer):
    def run(self):
        print_header("Installing extra package manager")
        if platform.is_mac:
            install_homebrew(force=True)
        elif platform.is_arch:
            install_aur_helper(force=True)
