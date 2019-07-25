#!/usr/bin/env python3
from venv import create
from os import makedirs
from pathlib import Path

from utils.installer import Installer
from utils.chalk import Color, print_line


class Main(Installer):
    def run(self):
        venv_home = Path.home().joinpath("code", "venv")
        venv_py3 = venv_home.joinpath("py3")
        makedirs(venv_home, exist_ok=True)

        if not venv_py3.is_dir():
            print_line("Setting up Python virtual env", Color.MAGENTA)
            create(str(venv_py3))
        else:
            print_line("Python virtual env already set up", Color.MAGENTA)
