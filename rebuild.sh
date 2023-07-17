#!/bin/sh
set -ex

# https://github.com/dotless-de/vagrant-vbguest
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-timezone

vagrant destroy --force && vagrant up
vagrant vbguest --do install
vagrant reload

# set +ex
vagrant ssh --color --timestamp --no-tty --command "/home/vagrant/.post-init-mate-theme.sh"
