#!/bin/sh
# set -e

# https://developer.hashicorp.com/vagrant/docs/cli/upload
vagrant upload scripts/check-versions.sh scripts/check-versions.sh > /dev/null

# https://stackoverflow.com/questions/20094118/ssh-into-vagrant-with-x-server-set-up
vagrant ssh \
	--command 'zsh -c "source ~/.zshrc 2>/dev/null; scripts/check-versions.sh"' 2>/dev/null \
	-- -X

# set +e
