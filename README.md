# Lee's dotfiles

Configures:

- Emacs
- Git
- GPG Agent
- Tmux
- Visual Studio Code
- ZSH
- Code font
- macOS Finder
- Golang
- System packages

## TL;DR

Run `./install.sh` from the repo root to install/configure the above.

## Structure

The main installer is `install.sh` at the root. Each configured system/section is in a separate script.
If a system has a folder for configuration files, the installer is in that folder. Otherwise it's at
the root. Each script can be called individually to install/configure only that section.

The installer can take an optional argument to run a specific installer without needing to know where
the script is.

Sections:

- `packages`
- `golang` - Doesn't actually install Go on macOS. But it still installed development packages.
- `fonts`
- `git`
- `tmux`
- `zsh` or `shell`
- `emacs`
- `gpg`
- `vscode` - Can take an optional second argument of `install` (install vscode, Linux only),
`link` (link configuration files), `ext` (install extensions), or `all` (same as no argument, do everything).
- `mac`
