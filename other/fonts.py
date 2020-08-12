import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import run_command
from utils.utils import settings, file_exists
import utils.platform as platform

FONT_LIBRARY = Path.home().joinpath(".fonts")
if platform.is_mac:
    FONT_LIBRARY = Path.home().joinpath("Library", "Fonts")


def install_font(url, dest):
    if not file_exists(dest):
        run_command(f"wget -q --show-progress -O '{dest}' '{url}'")
        return platform.is_linux
    return False


class Main(Installer):
    def run(self):
        print_header("Install fonts")
        os.makedirs(FONT_LIBRARY, exist_ok=True)

        reload_font = False
        for font in settings["fonts"]:
            reload_font = (
                install_font(font["remote"], FONT_LIBRARY.joinpath(font["name"]))
                or reload_font
            )

        if reload_font:
            print_line("Rescanning font caches")
            run_command("fc-cache -r")
