import json
import shlex
import os
import tempfile
from pathlib import Path
from shutil import copyfile as copy, copyfileobj
import urllib.request

from utils.system import run_command


def file_exists(filename):
    return Path(filename).is_file()


def dir_exists(dirname):
    p = Path(dirname)
    return p.is_dir() and not p.is_symlink()


def _load_settings(filename="settings.json"):
    with open(filename) as f:
        return json.load(f)


settings = _load_settings()


def link_file(src: Path, dest: Path, sudo=False, copy=False):
    dest_dir = str(dest.parent)
    src = str(src)
    dest = str(dest)

    # Check if environment overrides copy behavior
    if os.getenv("DOT_NO_LINK"):
        copy = True

    os.makedirs(dest_dir, exist_ok=True)

    # Copy or link new file
    if copy:
        copyfile(src, dest, sudo=sudo)
    else:
        cmd = f"ln -sfn {shlex.quote(src)} {shlex.quote(dest)}"
        if sudo:
            cmd = "sudo " + cmd
        run_command(cmd)


def link_files(filesets):
    for fileset in filesets:
        sudo = False
        if len(fileset) == 3:
            sudo = fileset[2]
        link_file(fileset[0], fileset[1], sudo=sudo)


def remove(path: Path, sudo=False):
    cmd = f"rm -rf {shlex.quote(str(path))}"
    if sudo:
        cmd = "sudo " + cmd
    run_command(cmd)


def move(src: Path, dest: Path, sudo=False):
    cmd = f"mv {shlex.quote(str(src))} {shlex.quote(str(dest))}"
    if sudo:
        cmd = "sudo " + cmd
    run_command(cmd)


def copyfile(src, dest, sudo=False):
    if sudo:
        run_command(f"sudo cp {shlex.quote(src)} {shlex.quote(dest)}")
    else:
        copy(src, dest)


def download_file(url, dest):
    with urllib.request.urlopen(url) as response, open(dest, "wb") as out_file:
        copyfileobj(response, out_file)


def download_tmp_file(url):
    temp_file = tempfile.NamedTemporaryFile(delete=False)
    with urllib.request.urlopen(url) as response:
        copyfileobj(response, temp_file)
    temp_file.close()
    return temp_file.name
