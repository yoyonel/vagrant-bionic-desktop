#!/bin/bash
# =============================================================================
# MINIMAL INSTALL — Operational desktop in minimum time
#
# Includes:  system update · nala · CLI tools · git · zsh+tmux ·
#            i3 + Polybar + Kitty + Rofi · LightDM · fonts · keyboard
#
# Excludes:  MATE · Docker · Python env · IDE · flatpak · audio/video ·
#            communication · graphics · NFS · utilities
#
# Usage:
#   vagrant up                         # this script (default)
#   INSTALL_MODE=full vagrant up       # full-install.sh
# =============================================================================

set -ex

ls scripts/

source scripts/.tools.sh

. scripts/.pre-init.sh

. scripts/install-apt-full.sh
. scripts/install-common.sh
. scripts/install-git.sh
. scripts/install-cli.sh

# Graphical stack: LightDM + i3 + Polybar + Kitty + Rofi (no MATE)
. scripts/install-windows_manager.sh
. scripts/install-i3-stack.sh

. scripts/install-fonts.sh
. scripts/install-keyboard.sh
. scripts/install-dconf.sh
. scripts/install-post_init.sh

set +x
