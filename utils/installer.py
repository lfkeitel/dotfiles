from typing import List


class Installer:
    args: List[str] = None
    settings = None

    def __init__(self, args: List[str], settings):
        self.args = args
        self.settings = settings
