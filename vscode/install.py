#!/usr/bin/env python3
from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header, print_line, Color
from utils.system import command_exists, install_pkg, run_command, run_command_no_out
from utils.utils import link_file, settings, dir_exists
import utils.platform as platform
from utils.shell import add_to_path

SCRIPT_DIR = Path(__file__).parent
SETTINGS_PATH = Path.home().joinpath(".config", "VSCodium", "User")
if platform.is_mac:
    SETTINGS_PATH = Path.home().joinpath(
        "Library", "Application Support", "VSCodium", "User"
    )

EXE_NAME = "vscodium"
if platform.is_mac:
    EXE_NAME = "code"


class InstallException(Exception):
    pass


class Main(Installer):
    def run(self):
        print_header("Setting up VSCodium")

        if platform.is_mac:
            add_to_path(
                "vscode",
                "/Applications/Visual Studio Code.app/Contents/Resources/app/bin",
            )
            add_to_path(
                "vscode", "/Applications/VSCodium.app/Contents/Resources/app/bin"
            )

        try:
            self.install_code()
        except InstallException:
            return

        self.link_files()
        self.install_extensions()

    def install_code(self):
        if command_exists(EXE_NAME):
            print_line(
                "VSCode already installed, update through the package manager",
                color=Color.MAGENTA,
            )
            return

        if platform.is_arch:
            install_pkg("vscodium-bin")
        elif platform.is_mac or platform.is_linux:
            print_line("Please install VSCodium first")
            raise InstallException()
        else:
            print_line("Unsupported distribution")
            raise InstallException()

    def link_files(self):
        print_line("Linking VSCode Settings", color=Color.MAGENTA)

        os.makedirs(SETTINGS_PATH, exist_ok=True)
        link_file(
            SCRIPT_DIR.joinpath("settings.json"),
            SETTINGS_PATH.joinpath("settings.json"),
        )
        link_file(
            SCRIPT_DIR.joinpath("keybindings.json"),
            SETTINGS_PATH.joinpath("keybindings.json"),
        )

        if dir_exists(SETTINGS_PATH.joinpath("snippets")):
            os.rmdir(SETTINGS_PATH.joinpath("snippets"))

        link_file(SCRIPT_DIR.joinpath("snippets"), SETTINGS_PATH.joinpath("snippets"))

    def install_extensions(self):
        print_line("Installing VSCodium Extensions", color=Color.MAGENTA)

        curr_exts = run_command_no_out(f"{EXE_NAME} --list-extensions")
        curr_exts = [s.lower() for s in curr_exts.stdout.split("\n") if s != ""]

        needed_exts = [
            s.lower() for s in settings["vscode"]["extensions"] if s not in curr_exts
        ]

        for e in needed_exts:
            run_command(f"{EXE_NAME} --force --install-extension {e}")
