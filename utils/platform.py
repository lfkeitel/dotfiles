import platform

is_mac = platform.system() == "Darwin"
is_linux = platform.system() == "Linux"

# These are filled in at module init
is_arch = False
is_ubuntu = False
is_fedora = False
distro_name = ""


def _read_distro_info():
    global distro_name
    global is_arch
    global is_ubuntu
    global is_fedora

    with open("/etc/os-release") as f:
        for line in f:
            if line.startswith("ID="):
                line = line.strip()
                distro_name = line.split("=")[1]
                break

    is_arch = distro_name == "arch"
    is_ubuntu = distro_name == "ubuntu"
    is_fedora = distro_name == "fedora"


_read_distro_info()
