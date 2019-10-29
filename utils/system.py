import subprocess
import shlex
import sys
import os

import utils.platform as platform


def command_exists(cmd):
    cmd = shlex.quote(cmd)
    proc = subprocess.run(
        ["which", cmd],
        stderr=subprocess.DEVNULL,
        stdout=subprocess.DEVNULL,
        stdin=subprocess.DEVNULL,
    )
    return proc.returncode == 0


def run_command(cmd, shell=False, cwd=None, text=None):
    if os.environ.get("DOTFILE_DEBUG", None):
        print(
            f"run_command() -> cmd={cmd} :: cwd={cwd} :: shell={shell} :: text={text}"
        )

    if not shell:
        cmd = shlex.split(cmd)
    return subprocess.run(
        cmd,
        stderr=sys.stderr,
        stdout=sys.stdout,
        stdin=sys.stdin,
        shell=shell,
        cwd=cwd,
        text=text,
    )


def run_command_no_out(cmd, shell=False, cwd=None, text=None):
    if os.environ.get("DOTFILE_DEBUG", None):
        print(
            f"run_command_no_out() -> cmd={cmd} :: cwd={cwd} :: shell={shell} :: text={text}"
        )

    if not shell:
        cmd = shlex.split(cmd)
    return subprocess.run(
        cmd, capture_output=True, encoding="utf_8", shell=shell, cwd=cwd, text=text
    )


def update_pkg_lists():
    if platform.is_ubuntu:
        run_command("sudo apt update")
    elif platform.is_mac:
        run_command("brew update")


def install_pkg(*pkgs, update_lists=False):
    if update_lists:
        update_pkg_lists()

    pkgs = " ".join(map(str, pkgs))
    if platform.is_ubuntu:
        run_command("sudo apt install -y" + pkgs)
    elif platform.is_fedora:
        run_command("sudo dnf install -y" + pkgs)
    elif platform.is_arch:
        run_command("yay -S --noconfirm --needed " + pkgs)
    elif platform.is_mac:
        run_command("brew install " + pkgs)


def install_apt_ppa(repo, update_lists=False):
    if not platform.is_ubuntu:
        return

    run_command("sudo add-apt-repository ppa:" + repo)
    if update_lists:
        update_pkg_lists()
