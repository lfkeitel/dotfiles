# Lee's dotfiles

## Requirements

- [PowerShell Core](https://github.com/PowerShell/PowerShell)

Use the `install-powershell.sh` script to install PowerShell.

## Applications

### Automatic (just run install.ps1):

- Inconsolata font
- Git
- Golang
- GPG Agent
- macOS Finder
- Node JS (with nvm and Yarn)
- PowerShell
- Python
- System packages
- Tmux
- Vim
- Visual Studio Code
- ZSH

### Manual (requires argument to install.ps1):

- Dart lang
- Docker
- Emacs
- Hexchat

## Supported Systems

- Ubuntu
- Fedora
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
    - `-Force` - Reinstall Go even if the required version is installed
