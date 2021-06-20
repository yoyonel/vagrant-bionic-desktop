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

# pyenv
figlet "Python 3.9.4"
pyenv install -s 3.9.4
pyenv global 3.9.4

export PIPX_DEFAULT_PYTHON=$HOME/.pyenv/shims/python
pipx uninstall poetry && pipx install poetry

# fisa-dev configuration
figlet "FISA-DEV"
nvim

#
figlet "ShadowApp (Béta)"
curl -s https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/check_driver.sh | sudo bash

# need user interaction ...
figlet "AUTO-CPUFREQ"
if ! command_exists auto-cpufreq; then
	git clone https://github.com/AdnanHodzic/auto-cpufreq.git /tmp/auto-cpufreq
	cd /tmp/auto-cpufreq
	sudo ./auto-cpufreq-installer
	sudo auto-cpufreq --install
	systemctl status auto-cpufreq
	cd -
else
	echo "auto-cpufreq already installed -> SKIP"
fi

# SSH
[ -f $HOME/.ssh/id_ed25519 ] && ssh-add -k $HOME/.ssh/id_ed25519

# 24bits color tests
# https://gist.github.com/XVilka/8346728
curl https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash

source ~/.zshrc
