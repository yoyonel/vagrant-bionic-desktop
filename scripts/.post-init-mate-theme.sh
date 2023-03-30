#!/bin/sh
set -ex

# WM - MATE
figlet "DCONF"
dconf load / <$HOME/.config/dconf/dconf.ini

figlet "WALLPAPERS"
gsettings set org.mate.background picture-filename "$HOME/.local/share/wallpapers/default.png"
gsettings set org.gnome.desktop.background picture-options "zoom"

# PyWal - set theme color from background
wal -n -q -e -i "$HOME/.local/share/wallpapers/default.png" >/dev/null

set +ex
