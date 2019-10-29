#!/usr/bin/env python3
from os import makedirs
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import install_pkg, run_command, command_exists
import utils.platform as platform
import other.packmgr as packmgr


class Main(Installer):
    def run(self):
        print_header("Installing system packages")
        if platform.is_mac:
            self.install_mac_pkgs()
        else:
            self.install_linux_pkgs()

    def install_mac_pkgs(self):
        packmgr.install_homebrew()
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
            packmgr.install_aur_helper()
            install_pkg(
                *self.settings["packages"]["linux"], *self.settings["packages"]["arch"]
            )

        run_command("sudo systemctl start haveged")
        run_command("sudo systemctl enable haveged")
