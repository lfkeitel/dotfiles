# Lee's dotfiles

## Requirements

- [PowerShell Core](https://github.com/PowerShell/PowerShell)

Use the `install-powershell.sh` script to install PowerShell.

## Applications

### Automatic (just run install.ps1):

- Fonts (Inconsolata, Fira Code, Font Awesome 5)
- Git
- Golang
- GPG Agent (Imports my personal keys and trusts ultimately)
- macOS Finder (Show all files)
- Node JS (with nvm and Yarn)
- PowerShell (Doesn't work on Arch)
- Python
- System packages
- Tmux
- Vim
- Visual Studio Code
- ZSH

### Manual (requires argument to install.ps1):

- Dart
- Rust
- Docker
- Hexchat (Some config files encrypted)
- Minicom (serial terminal)

## Supported Systems

- Ubuntu
- Fedora
- Arch
- macOS

## TL;DR

Run `./install.ps1` from the repo root to install/configure the above.

Run `./install.ps1 [application]` to run the installer for a specific application.

## Structure

The main installer is `install.ps1` at the root. Each configured module/application is in a separate script.
If a module has a folder for configuration files, the installer is in that folder. Otherwise it's in
`other`. Scripts may be ran directly, but it's recommended to use the main installer instead.

The installer can take an optional argument to run a specific installer.

## Applications taking extra arguments

- `golang`
    - `-Force` - Reinstall Go even if the required version is installed
- `gpg`
    - `-Force` - Setup GPG even if it's already done
- `vscode`
    - `-Install` - Install vscode, Linux only
    - `-Link` - Link configuration files
    - `-Ext` install extensions
- `dart`
    - `-Force` - Reinstall Dart even if the required version is installed


## Why PowerShell?

Originally my install scripts were written in normal Bash but I decided to move to
PowerShell for a couple reasons. One was simply to try something new. I had never
used PowerShell and it looked like an interesting shell runner. With PowerShell Core
and full Linux support it made it more compelling. Second is the language itself
is much more expressive and powerful than plain Bash/POSIX shell. Many operations
that were convoluted or ugly in Bash are very simple in PowerShell. It combines
the simplicity of a shell language with the power of a typical programming language.

If you don't want to use PowerShell, all the configs can be manually symlinked or
copied to their appropriate places.
