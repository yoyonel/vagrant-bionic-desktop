#!/bin/sh
set -ex

# [Not able to resolve dependencies when trying to install vagrant-libvirt #13510](https://github.com/hashicorp/vagrant/issues/13510#issuecomment-2431163553)
export VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT=1

# Install plugins only if missing (skip if already installed)
vagrant plugin list | grep -q vagrant-vbguest  || vagrant plugin install vagrant-vbguest
vagrant plugin list | grep -q vagrant-timezone || vagrant plugin install vagrant-timezone

vagrant destroy --force && vagrant up

vagrant ssh --color --no-tty --command "/home/vagrant/.post-init-mate-theme.sh" || true
vagrant ssh --color --no-tty --command "/home/vagrant/.post-init-flatpak.sh" || true
