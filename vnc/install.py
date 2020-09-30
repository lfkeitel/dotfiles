import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import install_pkg, run_command
from utils.utils import remove, file_exists, move, link_file, link_files
import utils.platform as platform

SCRIPT_DIR = Path(__file__).parent


class Main(Installer):
    def run(self):
        if not platform.is_arch:
            return

        print_header("Setting up VNC")

        install_pkg("tigervnc", "lxde-gtk3")

        if file_exists("/etc/pam.d/tigervnc.pacnew"):
            move("/etc/pam.d/tigervnc.pacnew", "/etc/pam.d/tigervnc")

        link_files(
            [
                [
                    SCRIPT_DIR.joinpath("vncserver.users"),
                    Path("/etc/tigervnc/vncserver.users"),
                    True,
                ],
                [
                    SCRIPT_DIR.joinpath("config"),
                    Path.home().joinpath(".vnc", "config"),
                    True,
                ],
            ]
        )

        run_command("sudo systemctl enable vncserver@:1")
        run_command("sudo systemctl start vncserver@:1")
