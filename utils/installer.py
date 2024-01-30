from typing import List
from pathlib import Path
import sys
import os
from importlib import import_module

from utils.chalk import print_error
from utils.utils import settings as default_settings


def exec_installer(path, name, args=[], settings=None):
    if os.environ.get("DOTFILE_DEBUG", None):
        print(
            f"exec_installer() -> path={path} :: name={name} :: args={args} :: settings={settings}"
        )

    path = Path(path)
    if not settings:
        settings = default_settings

    if path.is_dir():
        path = path.joinpath("install.py")

    if not path.is_file():
        print_error(f"Installer {name} is not found")
        return 1

    mod_path = path.parent
    mod_file = str(path.stem)

    # Add module path to start of path, import, then remove from path
    sys.path.insert(0, str(mod_path.absolute()))
    module = import_module("." + mod_file, str(mod_path).replace("/", "."))
    sys.path = sys.path[1:]

    try:
        m = getattr(module, "Main")(args, settings)
    except AttributeError:
        print_error(f"Installer {name} doesn't implement the installer interface")
        return 1

    m.run()

    return 0


class Installer:
    args: List[str] = []
    settings = {}

    def __init__(self, args: List[str], settings):
        self.args = args
        self.settings = settings

    def exec_installer(self, path, name):
        exec_installer(path, name, args=self.args, settings=self.settings)
