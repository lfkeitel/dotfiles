#!/usr/bin/env python3
import sys
import platform
import pathlib

from utils.utils import settings
from utils.chalk import print_banner, Color, print_error


def exec_installer(path, name):
    path = pathlib.Path(path)

    if path.is_dir():
        path = path.joinpath("install.py")

    if path.is_file():
        exec(open(path.absolute()).read())
    else:
        print_error(f"Installer {name} is not found")
        return 1

    return 0


def run_installer(name, args=[]):
    try:
        installer = settings["installers"][name]
    except:
        print_error(f"Installer {name} is not defined")
        return 1

    if "alias" in installer:
        alias_name = installer["alias"]
        installer = settings["installers"][alias_name]
        if not "path" in installer:
            installer["path"] = alias_name

    if "path" in installer:
        return exec_installer(installer["path"], name)
    else:
        return exec_installer(name, name)


def main(args):
    if platform.system() == "Windows":
        print("These dotfiles are written for Linux and macOS only")
        return 1

    if len(args) == 0:
        print("No args not supported yet")
        return 1

    print_banner("LEE'S DOTFILES", Color.BLUE)

    name = args[0]
    args = args[1:]

    return run_installer(name, args)


if __name__ == "__main__":
    exit(main(sys.argv[1:]))
