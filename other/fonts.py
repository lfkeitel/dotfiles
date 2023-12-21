import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import run_command
from utils.utils import settings, file_exists, download_tmp_file
import utils.platform as platform

FONT_LIBRARY = Path.home().joinpath(".fonts")
if platform.is_mac:
    FONT_LIBRARY = Path.home().joinpath("Library", "Fonts")


def install_font(url, dest):
    if not file_exists(dest):
        run_command(f"wget -q --show-progress -O '{dest}' '{url}'")
        return platform.is_linux
    return False


def extract_archive(font_config):
    file = download_tmp_file(font_config["remote"])
    run_command(f"unzip -j {file} '{font_config['files']}' -d {FONT_LIBRARY}")
    return platform.is_linux


def download_font(font_config):
    return install_font(
        font_config["remote"], FONT_LIBRARY.joinpath(font_config["name"])
    )


class Main(Installer):
    def run(self):
        print_header("Install fonts")
        os.makedirs(FONT_LIBRARY, exist_ok=True)

        reload_font = False
        for font in settings["fonts"]:
            if "type" not in font:
                reload_font = download_font(font) or reload_font
            elif font["type"] == "archive":
                reload_font = extract_archive(font) or reload_font

        if reload_font:
            print_line("Rescanning font caches")
            run_command("fc-cache -r")
