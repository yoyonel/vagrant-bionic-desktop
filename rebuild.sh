#!/bin/sh
set -ex

# [Not able to resolve dependencies when trying to install vagrant-libvirt #13510](https://github.com/hashicorp/vagrant/issues/13510#issuecomment-2431163553)
export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1

# https://github.com/dotless-de/vagrant-vbguest
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-timezone

vagrant destroy --force && vagrant up
# vagrant vbguest --do install
vagrant reload

# set +ex
vagrant ssh --color --timestamp --no-tty --command "/home/vagrant/.post-init-mate-theme.sh"
vagrant ssh --color --timestamp --no-tty --command "/home/vagrant/.post-init-flatpak.sh"
