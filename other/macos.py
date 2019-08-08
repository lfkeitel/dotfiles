from utils.installer import Installer
from utils.chalk import print_header
from utils.system import run_command
import utils.platform as platform


class Main(Installer):
    def run(self):
        if not platform.is_mac:
            return

        print_header("Setting up macOS Finder")
        # Setup Finder to show all files
        run_command("defaults write com.apple.finder AppleShowAllFiles YES", shell=True)
        run_command(
            "killall Finder /System/Library/CoreServices/Finder.app", shell=True
        )
