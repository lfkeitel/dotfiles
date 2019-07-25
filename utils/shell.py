from enum import Enum
import os
from pathlib import Path
import atexit

from utils.chalk import print_line
from utils.utils import copyfile, link_file, file_exists, dir_exists

_new_paths = {}

_ZSH_HOOKS_DIR = Path.home().joinpath(".local.zsh.d")
_ZSH_PATHS_DIR = _ZSH_HOOKS_DIR.joinpath("paths")

os.makedirs(_ZSH_HOOKS_DIR, exist_ok=True)


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


def add_zsh_hook(hook: Hook, name: str, file: str, copy=False):
    print_line(f"Adding {name} to ZSH {hook.value} hooks")

    if copy:
        copyfile(file, _ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))
    else:
        link_file(file, _ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


def remove_zsh_hook(hook: Hook, name: str):
    print_line(f"Removing {name} from ZSH {hook.value} hooks")
    os.remove(_ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


def zsh_hook_exists(hook: Hook, name: str):
    return file_exists(_ZSH_HOOKS_DIR.joinpath(hook.value, name + ".zsh"))


_FISH_CFG_DIR = Path.home().joinpath(".config", "fish")
_FISH_FUNCS_DIR = _FISH_CFG_DIR.joinpath("functions")
_FISH_HOOKS_DIR = _FISH_CFG_DIR.joinpath("hooks")
_FISH_PATHS_DIR = _FISH_HOOKS_DIR.joinpath("paths")

os.makedirs(_FISH_FUNCS_DIR, exist_ok=True)
os.makedirs(_FISH_HOOKS_DIR, exist_ok=True)


def add_fish_func(name: str, file: str, copy=False):
    print_line(f"Adding {name} to Fish functions")

    if copy:
        copyfile(file, _FISH_FUNCS_DIR.joinpath(name + ".fish"))
    else:
        link_file(file, _FISH_FUNCS_DIR.joinpath(name + ".fish"))


def remove_fish_func(name: str):
    print_line(f"Removing Fish function {name}")
    os.remove(_FISH_FUNCS_DIR.joinpath(name + ".fish"))


def add_fish_hook(hook: Hook, name: str, file: str, copy=False):
    print_line(f"Adding {name} to Fish {hook.value} hooks")

    if copy:
        copyfile(file, _FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))
    else:
        link_file(file, _FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def remove_fish_hook(hook: Hook, name: str):
    print_line(f"Removing {name} from Fish {hook.value} hooks")
    os.remove(_FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def fish_hook_exists(hook: Hook, name: str):
    return file_exists(_FISH_HOOKS_DIR.joinpath(hook.value, name + ".fish"))


def _write_path_data():
    for module, paths in _new_paths.items():
        paths = "\n".join(paths)

        if dir_exists(_ZSH_PATHS_DIR):
            with open(_ZSH_PATHS_DIR.joinpath(module), "w") as f:
                f.write(paths)

        if dir_exists(_FISH_PATHS_DIR):
            with open(_FISH_PATHS_DIR.joinpath(module), "w") as f:
                f.write(paths)


atexit.register(_write_path_data)
