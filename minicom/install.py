from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import run_command, install_pkg
import utils.platform as platform
from utils.utils import link_file


class Main(Installer):
    def run(self):
        print_header("Setting up Minicom")
        for file in ["dfl", "fast"]:
            link_file(
                Path(__file__).parent.joinpath(f".minirc.{file}"),
                Path.home().joinpath(f".minirc.{file}"),
            )
        install_pkg("minicom")

        if platform.is_linux:
            run_command("sudo usermod -a -G dialout lfkeitel $(whoami)", shell=True)
