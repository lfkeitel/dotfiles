from enum import Enum

banner_padding = 1
minimum_length = 20


class Color(Enum):
    BLACK = 30
    RED = 31
    GREEN = 32
    YELLOW = 33
    BLUE = 34
    MAGENTA = 35
    CYAN = 36
    WHITE = 37
    GRAY = 90
    LIGHT_RED = 91
    LIGHT_GREEN = 92
    LIGHT_YELLOW = 93
    LIGHT_BLUE = 94
    LIGHT_MAGENTA = 95
    LIGHT_CYAN = 96
    LIGHT_GRAY = 97

    def to_ansi_code(self):
        return f"\033[{self.value}m"

    @staticmethod
    def reset():
        return "\033[0m"

    @staticmethod
    def default():
        return "\033[39m"


def print_banner(message, color=Color.WHITE):
    length = max(len(message), minimum_length)
    banner_fril = "*" * (length + 4 + (banner_padding * 2))
    extra_padding = calc_extra_padding(message)
    color = color.to_ansi_code()

    print(f"{color}{banner_fril}{Color.default()}")
    print(f"{color}** {message}{extra_padding} **{Color.default()}")
    print(f"{color}{banner_fril}{Color.default()}")


def print_main_banner(message, color=Color.WHITE):
    length = max(len(message), minimum_length)
    banner_fril = "*" * (length + 4 + (banner_padding * 2))
    banner_fril_sp = " " * length
    extra_padding = calc_extra_padding(message)
    color = color.to_ansi_code()

    print(f"{color}{banner_fril}{Color.default()}")
    print(f"{color}** {banner_fril_sp} **{Color.default()}")
    print(f"{color}** {message}{extra_padding} **{Color.default()}")
    print(f"{color}** {banner_fril_sp} **{Color.default()}")
    print(f"{color}{banner_fril}{Color.default()}")


def print_header(message):
    print_banner(message, Color.GREEN)


def calc_extra_padding(message):
    padding = ""
    if len(message) < minimum_length:
        padding = " " * (minimum_length - len(message))
    return padding


def print_line(message, color=Color.WHITE):
    print(f"{color.to_ansi_code()}{message}{Color.default()}")


def print_warning(message):
    print_line(message, color=Color.YELLOW)


def print_error(message):
    print_line(message, color=Color.RED)
