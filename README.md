# Lee's dotfiles

## Requirements

- Python 3.6+

## Applications

### Automatic (just run install.py):

- Configs
  - calcurse
  - dunst
  - git
  - i3 (i3blocks)
  - misc. scripts
  - mpd
  - ncmpcpp
  - ranger
  - rofi
  - systemd user units
  - tmux
- Firefox (user settings)
- Fish (shell)
- Fonts (Inconsolata, Fira Code, Font Awesome 5)
- Golang
- GPG Agent (Imports my personal keys and trusts ultimately)
- Minicom (serial terminal)
- Node JS (with nvm and Yarn)
- Pacman (Arch only)
- Python
- System packages
- Vim
- Visual Studio Code
- ZSH

### Manual (requires argument to install.py):

- macOS Finder (Show all files)
- Docker
- Hexchat (Some config files encrypted)

## Supported Systems

- Ubuntu
- Fedora
- Arch
- macOS

## TL;DR

`./install.py` - Run all
`./install.py vscode` - Run one module
`./install.py -- vscode firefox` - Multiple modules with no args
`./install.py vscode vscodium -- firefox -- golang force` - Multiple modules
with args

## Structure

The main installer is `install.py` at the root. Each configured
module/application is in a separate script. If a module has a folder for
configuration files, the installer is in that folder. Otherwise it's in `other`.

The installer can take an optional argument to run a specific installer.

## Applications taking extra arguments

- `gpg`
  - `-Force` - Setup GPG even if it's already done
- `vscode`
  - `vscodium` - Install VSCodium instead of Visual Studio Code

## Personal Arch Repo

To use my personal arch repo add the following to your pacman config:

```
[personal]
Server = http://arch-repo.keitel.xyz
SigLevel = Required
```

You will need to add my key to you pacman GPG ring:

Fingerprint: `D2B6 240B 7E78 9CF8 177F BBC6 73E8 F0B8 E638 625F`

`pacman-key --recv-keys BBC673E8F0B8E638625F`
