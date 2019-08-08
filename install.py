#!/usr/bin/env python3
import sys
import platform

from utils.utils import settings
from utils.chalk import print_banner, Color, print_error
from utils.installer import exec_installer


def run_installer(name, args=[]):
    try:
        installer = settings["installers"][name]
    except AttributeError:
        print_error(f"Installer {name} is not defined")
        return 1

    if "alias" in installer:
        alias_name = installer["alias"]
        installer = settings["installers"][alias_name]
        if "path" not in installer:
            installer["path"] = alias_name

    if "path" in installer:
        return exec_installer(installer["path"], name, args, settings=settings)
    else:
        return exec_installer(name, name, args, settings=settings)


def main(args):
    if platform.system() == "Windows":
        print("These dotfiles are written for Linux and macOS only")
        return 1

    print_banner("LEE'S DOTFILES", Color.BLUE)

    if len(args) == 0:
        for name, i in settings["installers"].items():
            if "autorun" in i and i["autorun"]:
                run_installer(name)
        return 0
    else:
        name = args[0]
        args = args[1:]
        return run_installer(name, args)


if __name__ == "__main__":
    exit(main(sys.argv[1:]))
