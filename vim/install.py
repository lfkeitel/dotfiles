#!/usr/bin/env python3
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import command_exists, install_pkg, install_apt_ppa, run_command
from utils.utils import link_file
import utils.platform as platform


class Main(Installer):
    def run(self):
        print_header("Setting up Vim")
        self.check_nvim_installed()
        self.link_config()

    def check_nvim_installed(self):
        if command_exists("nvim"):
            return

        if platform.is_fedora:
            install_pkg("python2-neovim", "python3-neovim")
        elif platform.is_ubuntu:
            install_apt_ppa("neovim-ppa/stable", update_lists=True)
            install_pkg(
                "neovim", "python-dev", "python-pip", "python3-dev", "python3-pip"
            )
            run_command(
                "sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60"
            )
            run_command("sudo update-alternatives --config vi")
            run_command(
                "sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60"
            )
            run_command("sudo update-alternatives --config vim")
            run_command(
                "sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60"
            )
            run_command("sudo update-alternatives --config editor")

    def link_config(self):
        link_file(
            Path(__file__).parent.joinpath("nvim"),
            Path.home().joinpath(".config", "nvim"),
        )
