from enum import Enum
import os
from pathlib import Path
import atexit

from utils.chalk import print_line
from utils.utils import copyfile, link_file, file_exists, dir_exists

_new_paths = {}

ZSH_HOOKS_DIR = Path.home().joinpath(".local.zsh.d")
ZSH_PATHS_DIR = ZSH_HOOKS_DIR.joinpath("paths")

os.makedirs(ZSH_HOOKS_DIR, exist_ok=True)


def add_to_path(module, path):
    module = f"40-{module}"
    if module not in _new_paths:
        _new_paths[module] = []
    _new_paths[module].append(str(path))


class Hook(Enum):
    PRE = "pre"
    POST = "post"
    PRE_OH_MY_ZSH = "pre-oh-my-zsh"
    POST_OH_MY_ZSH = "post-oh-my-zsh"


def add_zsh_hook(hook: Hook, name: str, file: Path, copy=False):
    print_line(f"Adding {name} to ZSH {hook.value} hooks")

    if copy:
        copyfile(file, ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))
    else:
        link_file(file, ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


def remove_zsh_hook(hook: Hook, name: str):
    print_line(f"Removing {name} from ZSH {hook.value} hooks")
    os.remove(ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


def zsh_hook_exists(hook: Hook, name: str):
    return file_exists(ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


FISH_CFG_DIR = Path.home().joinpath(".config", "fish")
FISH_FUNCS_DIR = FISH_CFG_DIR.joinpath("functions")
FISH_HOOKS_DIR = FISH_CFG_DIR.joinpath("hooks")
FISH_PATHS_DIR = FISH_HOOKS_DIR.joinpath("paths")

os.makedirs(FISH_FUNCS_DIR, exist_ok=True)
os.makedirs(FISH_HOOKS_DIR, exist_ok=True)


def add_fish_func(name: str, file: Path, copy=False):
    print_line(f"Adding {name} to Fish functions")

    if copy:
        copyfile(file, FISH_FUNCS_DIR.joinpath(name + ".fish"))
    else:
        link_file(file, FISH_FUNCS_DIR.joinpath(name + ".fish"))


def remove_fish_func(name: str):
    print_line(f"Removing Fish function {name}")
    os.remove(FISH_FUNCS_DIR.joinpath(name + ".fish"))


def add_fish_hook(hook: Hook, name: str, file: Path, copy=False):
    print_line(f"Adding {name} to Fish {hook.value} hooks")

    if copy:
        copyfile(file, FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))
    else:
        link_file(file, FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def remove_fish_hook(hook: Hook, name: str):
    print_line(f"Removing {name} from Fish {hook.value} hooks")
    os.remove(FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def fish_hook_exists(hook: Hook, name: str):
    return file_exists(FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def _write_path_data():
    for module, paths in _new_paths.items():
        paths = "\n".join(paths) + "\n"

        if dir_exists(ZSH_PATHS_DIR):
            with open(ZSH_PATHS_DIR.joinpath(module), "w") as f:
                f.write(paths)

        if dir_exists(FISH_PATHS_DIR):
            with open(FISH_PATHS_DIR.joinpath(module), "w") as f:
                f.write(paths)


atexit.register(_write_path_data)
