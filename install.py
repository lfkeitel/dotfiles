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

    if not args:  # Install all autorun modules
        for name, i in settings["installers"].items():
            if "autorun" in i and i["autorun"]:
                run_installer(name)
        return 0
    elif len(args) == 1:  # Simple, run one module
        return run_installer(args[0], [])
    else:  # Run multiple modules, possibly with arguments
        module_playbook = parse_args(args)

        for name, play in module_playbook.items():
            exit_code = run_installer(name, play["args"])
            if exit_code != 0:
                return exit_code


def parse_args(args=[]):
    modules = {}

    if not args:
        return modules

    if args[0] == "--":
        for arg in args[1:]:
            modules[arg] = {"args": []}
        return modules

    while True:
        try:
            module_name = args.pop(0)
        except:
            break

        module_args = []

        while True:
            try:
                arg = args.pop(0)
            except:
                break
            if arg == "--":
                break
            module_args.append(arg)

        modules[module_name] = {"args": module_args}

    return modules


if __name__ == "__main__":
    exit(main(sys.argv[1:]))
