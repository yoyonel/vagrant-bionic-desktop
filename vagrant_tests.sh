#!/bin/sh
# set -e

# https://developer.hashicorp.com/vagrant/docs/cli/upload
vagrant upload scripts/check-versions.sh scripts/check-versions.sh > /dev/null

# Detect host VBox version and inject it into the guest for the GA version check
VBOX_HOST_VERSION=$(VBoxManage --version 2>/dev/null | sed 's/r.*//')

# https://stackoverflow.com/questions/20094118/ssh-into-vagrant-with-x-server-set-up
vagrant ssh \
	--command "VBOX_HOST_VERSION=${VBOX_HOST_VERSION} zsh -c 'source ~/.zshrc 2>/dev/null; scripts/check-versions.sh'" 2>/dev/null \
	-- -X
