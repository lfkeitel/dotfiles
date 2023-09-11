import os
from pathlib import Path

from utils.installer import Installer
from utils.chalk import print_header
from utils.system import run_command
from utils.utils import link_file
import utils.platform as platform

SCRIPT_DIR = Path(__file__).parent

units = [
    {
        'name': 'updatedb',
        'has_timer': True
    }
]

class Main(Installer):
    def run(self):
        if not platform.is_arch:
            return

        print_header("Setting up Systemd Units")

        for unit in units:
            link_file(
                SCRIPT_DIR.joinpath(f"{unit['name']}.service"),
                Path(f"/lib/systemd/system/{unit['name']}.service"),
                sudo=True,
            )

            if ('has_timer' in unit and unit['has_timer']):
                link_file(
                    SCRIPT_DIR.joinpath(f"{unit['name']}.timer"),
                    Path(f"/lib/systemd/system/{unit['name']}.timer"),
                    sudo=True,
                )

        run_command("sudo systemctl daemon-reload")

        for unit in units:
            if ('has_timer' in unit and unit['has_timer']):
                run_command(f"sudo systemctl enable {unit['name']}.timer")
                run_command(f"sudo systemctl start {unit['name']}.timer")
