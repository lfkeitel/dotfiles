from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header, print_line, Color
from utils.shell import add_to_path
from utils.system import run_command

SCRIPT_DIR = Path(__file__).parent
HOME_DIR = Path.home()
GOPATH = HOME_DIR.joinpath("go")


class Main(Installer):
    def run(self):
        print_header("Setting up Go")

        self.ensure_gopaths_dirs()
        self.install_go_pkgs()

        add_to_path("go", GOPATH.joinpath("bin"))

    def ensure_gopaths_dirs(self):
        os.makedirs(GOPATH.joinpath("src"), exist_ok=True)
        os.makedirs(GOPATH.joinpath("bin"), exist_ok=True)
        os.makedirs(GOPATH.joinpath("pkg"), exist_ok=True)

    def install_go_pkgs(self):
        print_line("Installing/updating Go packages", color=Color.MAGENTA)

        for pkg in self.settings["go"]["packages"]:
            proc = run_command(f"go get -u '{pkg}'")
            if proc.returncode == 0:
                print_line(f"Successfully downloaded {pkg}")
