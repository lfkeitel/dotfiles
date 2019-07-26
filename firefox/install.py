from pathlib import Path
from configparser import ConfigParser

from utils.installer import Installer
from utils.chalk import print_header
from utils.utils import link_file

MOZILLA_DIR = Path.home().joinpath(".mozilla", "firefox")
SCRIPT_DIR = Path(__file__).parent


class Main(Installer):
    def run(self):
        print_header("Setting up Firefox profile")

        profiles = ConfigParser()
        profiles.read(MOZILLA_DIR.joinpath("profiles.ini"))

        default_profile = ""
        for k, v in profiles.items():
            if v.get("Default", fallback=0) == "1":
                default_profile = v
                break

        profile_dir = MOZILLA_DIR.joinpath(default_profile.get("Path"))
        link_file(SCRIPT_DIR.joinpath("user.js"), profile_dir.joinpath("user.js"))
        link_file(SCRIPT_DIR.joinpath("chrome"), profile_dir.joinpath("chrome"))
