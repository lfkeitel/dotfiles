from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header
from utils.utils import link_file
from utils.shell import (
    add_to_path,
    add_fish_func,
    Hook,
    FISH_CFG_DIR,
    FISH_HOOKS_DIR,
    add_fish_hook,
)

script_dir = Path(__file__).parent
home_dir = Path.home()


class Main(Installer):
    def run(self):
        print_header("Setting up Fish")

        self.link_fish_configs()
        self.install_plugins()
        self.setup_hooks()

    def link_fish_configs(self):
        link_file(
            script_dir.joinpath("config.fish"), FISH_CFG_DIR.joinpath("config.fish")
        )
        link_file(
            script_dir.joinpath("aliases.fish"), FISH_CFG_DIR.joinpath("aliases.fish")
        )
        link_file(
            script_dir.joinpath("functions.fish"),
            FISH_CFG_DIR.joinpath("functions.fish"),
        )

    def install_plugins(self):
        add_fish_func("docker-host", script_dir.joinpath("docker-host.fish"))

    def setup_hooks(self):
        os.makedirs(FISH_HOOKS_DIR.joinpath("pre"), exist_ok=True)
        os.makedirs(FISH_HOOKS_DIR.joinpath("post"), exist_ok=True)
        os.makedirs(FISH_HOOKS_DIR.joinpath("paths"), exist_ok=True)

        add_to_path("local", home_dir.joinpath("bin"))
        add_to_path("local", home_dir.joinpath(".scripts"))
        add_to_path("local", home_dir.joinpath(".local/scripts"))

        add_fish_hook(Hook.POST, "10-vars", script_dir.joinpath("vars.fish"))
        add_fish_hook(Hook.POST, "10-nnn-setup", script_dir.joinpath("nnn-setup.fish"))
        add_fish_hook(Hook.POST, "10-git", script_dir.joinpath("git.fish"))
        add_fish_hook(Hook.PRE, "10-theme", script_dir.joinpath("theme.fish"))
