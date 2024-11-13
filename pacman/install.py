import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import install_pkg, run_command
from utils.utils import remove, link_file, template_file
import utils.platform as platform

SCRIPT_DIR = Path(__file__).parent


class Main(Installer):
    def run(self):
        if not platform.is_arch:
            return

        print_header("Setting up Pacman")
        template_file(
            SCRIPT_DIR.joinpath("pacman.conf"),
            Path("/etc/pacman.conf"),
            {"mirror_file": "/etc/pacman.d/mirror-local"},
            sudo=True,
            mode=0o644,
        )

        install_pkg("reflector", "arch-audit", "kernel-modules-hook")

        # Enable kernel module cleanup job
        run_command("sudo systemctl daemon-reload")
        run_command("sudo systemctl enable linux-modules-cleanup")

        # Hooks are symlinked individually to allow local hooks that are
        # not managed by this installer.
        with os.scandir(SCRIPT_DIR.joinpath("hooks")) as hooks:
            hook_dir = "/etc/pacman.d/hooks/"
            for item in hooks:
                link_file(item.path, Path(hook_dir + item.name), sudo=True)

        link_file(
            SCRIPT_DIR.joinpath("reflector.conf"),
            Path("/etc/xdg/reflector/reflector.conf"),
            sudo=True,
        )

        run_command("sudo systemctl enable reflector.timer")
        run_command("sudo systemctl start reflector.timer")
