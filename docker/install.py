from pathlib import Path
import json

from utils.installer import Installer
from utils.chalk import print_header
from utils import platform
from utils.system import command_exists, install_pkg, run_command


class Main(Installer):
    def run(self):
        if not platform.is_linux:
            return

        print_header("Setting up Docker")
        self.install_docker()

        print_header("Setting up Docker Credential Store")
        self.setup_cred_store()

    def install_docker(self):
        if not command_exists("docker"):
            install_pkg("docker-bin")

    def setup_cred_store(self):
        # Get current config
        docker_config = Path.home().joinpath(".docker", "config.json")
        with open(docker_config) as f:
            config = json.load(f)

        # Check if credential store is already configured
        if "credsStore" not in config:
            install_pkg("docker-credential-secretservice", "gnome-keyring")

            config["auths"] = {}  # Reset auths to remove any existing passwords
            config["credsStore"] = "secretservice"

            # Write out new config, make it pretty
            with open(docker_config, "w") as f:
                json.dump(config, f, indent=2)

            run_command("sudo systemctl restart docker")
