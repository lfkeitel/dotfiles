import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import install_pkg
from utils.shell import link_file
from utils.utils import remove
import utils.platform as platform

SCRIPT_DIR = Path(__file__).parent


class Main(Installer):
    def run(self):
        if not platform.is_arch:
            return

        print_header("Setting up Pacman")
        link_file(
            SCRIPT_DIR.joinpath("pacman.conf"), Path("/etc/pacman.conf"), sudo=True
        )
        remove("/opt/reflector_sync.sh")
        link_file(
            SCRIPT_DIR.joinpath("reflector_sync.sh"),
            Path("/usr/local/bin/reflector_sync"),
            sudo=True,
        )

        install_pkg("reflector", "arch-audit")

        with os.scandir(SCRIPT_DIR.joinpath("hooks")) as hooks:
            hook_dir = "/etc/pacman.d/hooks/"
            for item in hooks:
                link_file(item.path, Path(hook_dir + item.name), sudo=True)
