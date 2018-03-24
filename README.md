# Lee's dotfiles

## Requirements

- [PowerShell Core](https://github.com/PowerShell/PowerShell)

Configures:

Automatic (just run install.ps1):

- ZSH
- Emacs
- Git
- GPG Agent
- Tmux
- Visual Studio Code
- Code font
- macOS Finder
- Golang
- System packages
- NPM (prefix)
- Vim

Manual (requires argument to install.ps1):

- Docker
- Hexchat (Server list)

## Supported Systems

- Ubuntu
- Fedora
- macOS

## TL;DR

Run `./install.ps1` from the repo root to install/configure the above.

## Structure

The main installer is `install.ps1` at the root. Each configured system/section is in a separate script.
If a system has a folder for configuration files, the installer is in that folder. Otherwise it's in
`other`. DO NOT run an install script by itself. Use the root `install.ps1` script with a section
parameter to configure a single application.

The installer can take an optional argument to run a specific installer.

Sections:

- `packages`
- `golang` - Doesn't actually install Go on macOS. But it still installs development packages.
- `fonts`
- `git`
- `tmux`
- `zsh` or `shell`
- `emacs`
- `gpg` - Can take an optional argument of `force`.
- `vscode` - Can take an optional second argument of `install` (install vscode, Linux only),
`link` (link configuration files), `ext` (install extensions), or `all` (same as no argument, do everything).
- `mac` - Only runs on macOS
- `npm`
- `vim`
- `docker`
- `hexchat`
