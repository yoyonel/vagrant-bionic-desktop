#!/bin/sh
set -ex

. .post-init-mate-theme.sh

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
	sudo /tmp/auto-cpufreq/auto-cpufreq-installer
	# FIX: need to be portable/generic (CI, laptop, desktop, etc ...)
	sudo auto-cpufreq --install
	systemctl status auto-cpufreq
else
	echo "auto-cpufreq already installed -> SKIP"
fi

# SSH
[ -f $HOME/.ssh/id_ed25519 ] && ssh-add -k $HOME/.ssh/id_ed25519

# 24bits color tests
# https://gist.github.com/XVilka/8346728
curl https://gist.githubusercontent.com/lifepillar/09a44b8cf0f9397465614e622979107f/raw/24-bit-color.sh | bash

source ~/.zshrc
