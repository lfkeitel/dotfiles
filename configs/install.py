from pathlib import Path
import os

from utils.installer import Installer, exec_installer
from utils.chalk import print_header
from utils.system import run_command
from utils.utils import link_file
from utils import platform

SCRIPT_DIR = Path(__file__).parent
HOME_DIR = Path.home()


class Main(Installer):
    def run(self):
        print_header("Setting up Generic Configs")

        link_file(SCRIPT_DIR.joinpath("scripts"), HOME_DIR.joinpath(".scripts"))

        with os.scandir(SCRIPT_DIR.joinpath("config")) as configs:
            config_dir = HOME_DIR.joinpath(".config")
            for item in configs:
                if item.is_dir():
                    link_file(item.path, config_dir.joinpath(item.name))

        if not platform.is_mac:
            run_command("systemctl --user daemon-reload")
            run_command("systemctl --user enable newsboat.timer")
            run_command("systemctl --user enable random_wallpaper.timer")
            if platform.is_arch:
                run_command("systemctl --user enable pacupdate.timer")

        self.exec_installer("configs/home", "home")
