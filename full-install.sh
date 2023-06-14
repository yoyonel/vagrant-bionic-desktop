#!/bin/bash

# set -ex
set -x

ls scripts/

source scripts/.tools.sh

. scripts/install-apt-full.sh
. scripts/install-common.sh
. scripts/install-desktop.sh
. scripts/install-python.sh
. scripts/install-git.sh
. scripts/install-cli.sh
. scripts/install-audio_video.sh
. scripts/install-communication_news.sh
. scripts/install-utilities.sh
. scripts/install-graphics_photography.sh
. scripts/install-windows_manager.sh
. scripts/install-dconf.sh
. scripts/install-system.sh
. scripts/install-system-and-tools.sh
. scripts/install-virtualbox.sh
. scripts/install-ide.sh
. scripts/install-fonts.sh
. scripts/install-keyboard.sh
. scripts/install-nfs_synology.sh
. scripts/install-post_init.sh

set +x
