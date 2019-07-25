#!/usr/bin/env python3
import sys
import platform
import pathlib
from importlib import import_module

from utils.utils import settings
from utils.chalk import print_banner, Color, print_error


def exec_installer(path, name, args=[]):
    path = pathlib.Path(path)

    if path.is_dir():
        path = path.joinpath("install.py")

    if not path.is_file():
        print_error(f"Installer {name} is not found")
        return 1

    mod_path = str(path.parent)
    mod_file = str(path.stem)

    module = import_module("." + mod_file, mod_path)
    try:
        m = getattr(module, "Main")(args, settings)
        m.run()
    except AttributeError:
        print_error(f"Installer {name} doesn't implement the installer interface")
        return 1

    return 0


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
        return exec_installer(installer["path"], name, args)
    else:
        return exec_installer(name, name, args)


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
