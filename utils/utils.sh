#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export DOTFILE_INSTALLER=1

source "$SCRIPT_DIR/system.sh"
source "$SCRIPT_DIR/packages.sh"
source "$SCRIPT_DIR/display.sh"
source "$SCRIPT_DIR/install.sh"
source "$SCRIPT_DIR/shell.sh"

unset SCRIPT_DIR
