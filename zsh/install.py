from pathlib import Path
import os

from utils.installer import Installer
from utils.chalk import print_header, print_line
from utils.system import run_command
import utils.platform as platform
from utils.utils import link_file, dir_exists, file_exists
from utils.shell import add_to_path, add_zsh_hook, Hook

script_dir = Path(__file__).parent
home_dir = Path.home()
omz_dir = home_dir.joinpath(".oh-my-zsh")
zsh_custom = omz_dir.joinpath("custom")
zsh_plugin_dir = zsh_custom.joinpath("plugins")
zsh_theme_dir = zsh_custom.joinpath("themes")


def install_zsh_plugin(plugin, remote):
    print_line(f"Installing plugin {plugin}")
    plugin_dir = zsh_plugin_dir.joinpath(plugin)

    if not dir_exists(plugin_dir):
        run_command(f"git clone '{remote}' '{plugin_dir}'")

    run_command("git pull", cwd=plugin_dir)


class Main(Installer):
    def run(self):
        print_header("Setting up ZSH")

        self.link_zsh_configs()
        self.setup_oh_my_zsh()
        self.install_plugins()
        self.install_theme()
        self.setup_hooks()
        self.setup_autocomplete()
        self.setup_project_list()

    def link_zsh_configs(self):
        link_file(script_dir.joinpath(".zshrc"), home_dir.joinpath(".zshrc"))
        link_file(
            script_dir.joinpath(".zsh_aliases"), home_dir.joinpath(".zsh_aliases")
        )
        link_file(
            script_dir.joinpath(".zsh_functions"), home_dir.joinpath(".zsh_functions")
        )

    def setup_oh_my_zsh(self):
        if dir_exists(omz_dir) and not file_exists(omz_dir.joinpath("oh-my-zsh.sh")):
            os.rmdir(omz_dir)

        # oh-my-zsh
        if not dir_exists(omz_dir):
            print_line("Installing oh-my-zsh")
            run_command("bash " + script_dir.joinpath("install-oh-my-zsh.sh"))

            if platform.is_mac:
                run_command(
                    'sudo dscl . -create "/Users/${USER}" UserShell /usr/local/bin/zsh',
                    shell=True,
                )

        # Update Oh My ZSH
        run_command("git pull --rebase --stat origin master", cwd=omz_dir)

    def install_plugins(self):
        for plugin in self.settings["zsh"]["plugins"]:
            install_zsh_plugin(plugin["name"], plugin["remote"])

        link_file(
            script_dir.joinpath("docker-host.sh"),
            zsh_plugin_dir.joinpath("docker-host", "docker-host.plugin.zsh"),
        )

    def install_theme(self):
        link_file(
            script_dir.joinpath("lfk.zsh-theme"),
            zsh_theme_dir.joinpath("lfk.zsh-theme"),
        )

    def setup_hooks(self):
        os.makedirs(home_dir.joinpath(".local.zsh.d", "pre"), exist_ok=True)
        os.makedirs(home_dir.joinpath(".local.zsh.d", "post"), exist_ok=True)
        os.makedirs(home_dir.joinpath(".local.zsh.d", "paths"), exist_ok=True)

        # Convert old custom into new hooks system
        # Shouldn't be needed anymore, but just in case
        if file_exists(home_dir.joinpath(".local.zsh")):
            run_command(
                'mv -n "$HOME/.local.zsh" "$HOME/.local.zsh.d/post/00-old-local.zsh"',
                shell=True,
            )

        add_to_path("zsh", home_dir.joinpath("bin"))
        add_to_path("zsh", home_dir.joinpath(".scripts"))
        add_to_path("zsh", home_dir.joinpath(".local/scripts"))

        add_zsh_hook(Hook.POST, "10-vars", script_dir.joinpath("vars.zsh"))
        add_zsh_hook(Hook.POST, "10-nnn-setup", script_dir.joinpath("nnn-setup.zsh"))

    def setup_autocomplete(self):
        link_file(
            script_dir.joinpath("completion"), home_dir.joinpath(".zsh", "completion")
        )

    def setup_project_list(self):
        project_list = home_dir.joinpath(".project.list")
        if not file_exists(project_list):
            with open(project_list) as f:
                f.write("")

        link_file(project_list, home_dir.joinpath(".warprc"))

        home_dir.joinpath("code").mkdir(parents=True, exist_ok=True)
