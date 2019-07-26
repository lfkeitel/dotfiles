from pathlib import Path

from utils.chalk import print_header
from utils.installer import Installer
from utils.utils import link_file

SCRIPT_DIR = Path(__file__).parent
HOME_DIR = Path.home()


def link_config(path):
    link_file(SCRIPT_DIR.joinpath(path), HOME_DIR.joinpath(path))


class Main(Installer):
    def run(self):
        print_header("Setting up profile")
        link_config(".profile")

        print_header("Setting up tmux")
        link_config(".tmux.conf")

        print_header("Setting up makepkg")
        link_config(".makepkg.conf")

        print_header("Setting up Git")
        link_config(".gitconfig")
        link_config(".gitignore")
        link_config(".gitmessage")

        print_header("Setting up ncmpcpp")
        link_config(".ncmpcpp/bindings")
        link_config(".ncmpcpp/config")

        print_header("Setting up Calcurse")
        link_config(".calcurse/conf")
        link_config(".calcurse/keys")
