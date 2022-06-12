#!/usr/bin/env python3
from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import command_exists, install_pkg, install_apt_ppa, run_command
from utils.utils import link_file, download_file
import utils.platform as platform

_VIM_PLUGGED_SRC = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"


class Main(Installer):
    def run(self):
        print_header("Setting up Vim")
        if not "plugged" in self.args:
            self.check_nvim_installed()
            self.link_config()
        self.download_vim_plugged()
        run_command("nvim +PlugInstall +qall")

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
            Path(__file__).parent.joinpath(".vimrc"),
            Path.home().joinpath(".config", "nvim", "init.vim"),
        )

    def download_vim_plugged(self):
        local = Path.home().joinpath(".local", "share", "nvim", "site", "autoload")
        os.makedirs(local, exist_ok=True)
        download_file(_VIM_PLUGGED_SRC, str(local.joinpath("plug.vim")))
