#!/usr/bin/env python3
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import run_command, install_pkg
from utils.shell import Hook, add_fish_hook
from utils.utils import file_exists

SCRIPT_DIR = Path(__file__).parent
HOME_DIR = Path.home()

class Main(Installer):
    def run(self):
        print_header("Setting up opam")
        install_pkg("opam")

        if not file_exists(HOME_DIR.joinpath(".opam", "config")):
            run_command("opam init -n")

        add_fish_hook(Hook.POST, "10-opam", SCRIPT_DIR.joinpath("setuphook.fish"))
        run_command("opam install -y dune utop ocaml-lsp-server merlin odoc ocamlformat dune-release")
