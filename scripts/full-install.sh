#!/bin/sh
set -ex

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

package_installed() {
	dpkg-query --list | grep -i "$@" >/dev/null 2>&1
}

# Figlet
! command_exists figlet && sudo apt-get -y install figlet

# [https://serverfault.com/a/670688](dpkg-reconfigure: unable to re-open stdin: No file or directory)
export DEBIAN_FRONTEND=noninteractive

# https://askubuntu.com/a/1107071
# http://manpages.ubuntu.com/manpages/xenial/en/man5/apt.conf.5.html
sudo sh -c "echo 'APT::Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries"

# APT
##########################
#
#     /\   |  __ |__   __|
#    /  \  | |__) | | |
#   / /\ \ |  ___/  | |
#  / ____ \| |      | |
# /_/    \_|_|      |_|
#
##########################
figlet "APT: FULL"
sudo apt-get -y --fix-broken install
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove --purge
sudo apt-get -y autoclean

# COMMON
###########################################
#
#  / ____/ __ \|  \/  |  \/  |/ __ \| \ | |
# | |   | |  | | \  / | \  / | |  | |  \| |
# | |   | |  | | |\/| | |\/| | |  | | . ` |
# | |___| |__| | |  | | |  | | |__| | |\  |
#  \_____\____/|_|  |_|_|  |_|\____/|_| \_|
#
###########################################
figlet "APT: Install"
sudo apt-get -y install \
	locate wget curl htop \
	git git-extras \
	moreutils \
	libc++1 \
	time

figlet "COMMAND-NOT-FOUND"
if ! command_exists command-not-found; then
	sudo apt-get -y install command-not-found
	sudo apt-file update
fi

figlet "ZSH"
if ! command_exists zsh; then
	sudo apt-get -y install zsh
else
	echo "zsh: skip"
fi

figlet "DESKTOP" "MATE+LIGHTDM"
# Optional: Use LightDM login screen (-> not required to run "startx")
# https://github.com/mate-desktop/mate-system-monitor
# https://github.com/mate-desktop/mate-applets
# https://ubuntu-mate.community/t/how-to-remove-home-folder-from-desktop/498/9
sudo apt-get -y install \
	mate-core \
	mate-system-monitor mate-system-monitor-common \
	mate-applets mate-applets-common \
	mate-tweak \
	lightdm lightdm-gtk-greeter

# PYTHON
#  _______     _________ _    _  ____  _   _
# |  __ \ \   / /__   __| |  | |/ __ \| \ | |
# | |__) \ \_/ /   | |  | |__| | |  | |  \| |
# |  ___/ \   /    | |  |  __  | |  | | . ` |
# | |      | |     | |  | |  | | |__| | |\  |
# |_|      |_|     |_|  |_|  |_|\____/|_| \_|
#
figlet "PYTHON"
sudo apt-get -y install python3-pip python3-venv python3-pip python3-argcomplete

figlet "PIPX"
! command_exists pipx && python3 -m pip install --user pipx
python3 -m pipx ensurepath
export PATH=$PATH:"$HOME/.local/bin"

figlet "PYENV"
# if ! command_exists pyenv; then
if [ ! -d $HOME/.pyenv ]; then
	# Python (dev) dependencies for installing python interpreters from sources
	sudo apt-get install -y \
		make build-essential libssl-dev zlib1g-dev libbz2-dev \
		libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
		xz-utils tk-dev libffi-dev liblzma-dev
	# if [ -d $HOME/.pyenv ]; then
	#     echo "$HOME/.pyenv exist by pyenv can't be found ! Maybe a problem in setting stage ..."
	#     rm -rf $HOME/.pyenv
	# fi
	curl -s https://pyenv.run | zsh
else
	echo "pyenv already installed => SKIP"
fi

figlet "POETRY"
if ! command_exists poetry; then
	if command_exists pipx; then
		pipx install poetry
	else
		echo "POETRY - missing dependency: pipx - FAIL"
	fi
else
	echo "poetry already installed -> SKIP"
fi

# GIT
########################
#  _____ _____ _______
#  / ____|_   _|__   __|
# | |  __  | |    | |
# | | |_ | | |    | |
# | |__| |_| |_   | |
#  \_____|_____|  |_|
#
########################
figlet "PRE-COMMIT"
if ! command_exists pre-commit; then
	if command_exists pipx; then
		pipx install pre-commit
	else
		echo "PRE-COMMIT - missing dependency: pipx - FAIL"
	fi
else
	echo "pre-commit already installed -> SKIP"
fi

figlet "TIG"
! command_exists tig && sudo apt-get -y install tig

figlet "GitHub cli"
if ! command_exists gh; then
	# https://github.com/cli/cli/releases
	wget -q https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_linux_amd64.deb -O /tmp/gh_1.11.0_linux_amd64.deb
	sudo dpkg -i /tmp/gh_1.11.0_linux_amd64.deb
else
	echo "github cli already installed -> SKIP"
fi

figlet "DELTA-DIFF"
if ! command_exists delta; then
	# https://github.com/dandavison/delta/releases
	wget -q https://github.com/barnumbirr/delta-debian/releases/download/0.6.0-1/delta-diff_0.6.0-1_amd64_debian_buster.deb -O /tmp/delta-diff_0.6.0-1_amd64_debian_buster.deb
	sudo dpkg -i /tmp/delta-diff_0.6.0-1_amd64_debian_buster.deb
else
	echo "delta-diff already installed -> SKIP"
fi

figlet "GITA"
if ! command_exists gita; then
	# https://github.com/nosarthur/gita
	pip3 install -U gita
	mkdir -p $HOME/.config/gita
	curl -fsSL https://raw.githubusercontent.com/nosarthur/gita/master/.gita-completion.zsh -o $HOME/.config/gita/.gita-completion.zsh
else
	echo "gita already installed -> SKIP"
fi

# CLI
#   _____ _      _____
#  / ____| |    |_   _|
# | |    | |      | |
# | |    | |      | |
# | |____| |____ _| |_
#  \_____|______|_____|
#
figlet "OH-MY-ZSH"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Install Oh-My-ZSH ..."
	sh -c "$(wget -q https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" >/dev/null
else
	echo "oh-my-zsh: skip"
fi
### plugins/widgets
OMZ_PLUGINS_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins
if [ ! -d "$OMZ_PLUGINS_DIR/zsh-autosuggestions" ]; then
	git clone http://github.com/zsh-users/zsh-autosuggestions "$OMZ_PLUGINS_DIR/zsh-autosuggestions"
fi
if [ ! -d "$OMZ_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$OMZ_PLUGINS_DIR/zsh-syntax-highlighting"
fi
if [ ! -d "$OMZ_PLUGINS_DIR/forgit" ]; then
	git clone https://github.com/jamespeapen/forgit.git "$OMZ_PLUGINS_DIR/forgit"
fi
if [ ! -d "$OMZ_PLUGINS_DIR/zsh-completions" ]; then
	git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
fi
# OH-MY-ZSH Theme: Powerline9K
if [ ! -d ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel9k ]; then
	git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel9k
fi

# DirEnv
figlet "DIRENV"
! command_exists direnv && curl -sfL https://direnv.net/install.sh | bash

figlet "TMUX"
sudo apt install -y tmux
# bc: use by tmux-plugins/tmux-docker
! command_exists bc && sudo apt-get -y install tmux bc
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	figlet "TMUX-PLUGINS"
	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

figlet "RANGER"
# ranger: Console file manager with VI key bindings.
if ! command_exists ranger; then
	sudo apt-get -y install ranger
else
	echo "ranger alread installer -> SKIP"
fi

figlet "FZF"
! command_exists fzf && sudo apt-get -y install fzf

figlet "LSD"
if ! command_exists lsd; then
	cd /tmp
	# https://github.com/Peltoche/lsd
	wget -q https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb
	sudo dpkg -i lsd_0.20.1_amd64.deb
	cd -
else
	echo "lsd already installed => SKIP"
fi

figlet "AUTOJUMP"
! command_exists autojump && sudo apt-get -y install autojump

figlet "GRC"
! command_exists grc && sudo apt-get -y install grc

figlet "PYWAL"
if ! command_exists wal; then
	sudo apt-get -y install imagemagick
	pipx install pywal
else
	echo "pywal already installed -> SKIP"
fi

figlet "NEOFETCH"
! command_exists neofetch && sudo apt-get -y install neofetch

figlet "MOST"
! command_exists most && sudo apt-get -y install most

figlet "TREE"
! command_exists tree && sudo apt-get -y install tree

figlet "X[CLIP&SEL]"
! command_exists xclip && sudo apt-get -y install xclip xsel

figlet "BAT"
if ! command_exists bat; then
	wget -q https://github.com/sharkdp/bat/releases/download/v0.18.0/bat_0.18.0_amd64.deb -O /tmp/bat_0.18.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.18.0_amd64.deb
else
	echo "bat already installed -> SKIP"
fi

figlet "JQ"
! command_exists jq && sudo apt-get -y install jq

figlet "RIPGREP"
# ripgrep recursively searches directories for a regex pattern
! command_exists rg && sudo apt-get -y install ripgrep

figlet "SILVERSEARCHER-AG"
# A code searching tool similar to ack, with a focus on speed.
# (ack is a code-searching tool, similar to grep but optimized for programmers searching large trees of source code.)
! command_exists ag && sudo apt-get -y install silversearcher-ag

figlet "RSYNC"
! command_exists rsync && sudo apt-get -y install rsync

figlet "TLDR"
! command_exists tldr && sudo apt-get -y install tldr
tldr tldr >/dev/null

figlet "NCDU"
# https://dev.yorhel.nl/ncdu
! command_exists ncdu && sudo apt-get -y install ncdu

figlet "DUF"
# https://github.com/muesli/duf
if ! command_exists duf; then
	# snap installation
	if command_exists snap; then
		sudo snap install duf-utility
	fi
fi

figlet "NMAP"
! command_exists nmap && sudo apt-get -y install nmap

figlet "MONITORING"
# dnsutils -> dig: DNS Lookup utility
# net-tools -> netstat: Displays network-related information such as open connections, open socket ports, etc.
sudo apt-get -y install \
	htop \
	glances \
	iotop \
	bmon \
	net-tools \
	dnsutils
if ! command_exists gotop; then
	if [ ! -d "/tmp/gotop" ]; then
		git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
	fi
	cd /tmp/gotop
	bash ./scripts/download.sh
	sudo cp gotop /usr/local/bin
	cd -
fi

figlet "SPEEDTEST"
if ! command_exists speedtest; then
	curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
	sudo apt-get -y install speedtest
else
	echo "speedtest already installed -> SKIP"
fi

figlet "PARALLEL"
# if ! command_exists parallel; then
# need `parallel` from parallel package not from more-utils
sudo apt-get -y install parallel
# else
# 	echo "parallel already installed -> SKIP"
# fi

# Audio & Video
#                    _ _                 __      ___     _
#     /\            | (_)         ___    \ \    / (_)   | |
#    /  \  _   _  __| |_  ___    ( _ )    \ \  / / _  __| | ___  ___
#   / /\ \| | | |/ _` | |/ _ \   / _ \/\   \ \/ / | |/ _` |/ _ \/ _ \
#  / ____ \ |_| | (_| | | (_) | | (_>  <    \  /  | | (_| |  __/ (_) |
# /_/    \_\__,_|\__,_|_|\___/   \___/\/     \/   |_|\__,_|\___|\___/
#
figlet "AVIDEMUX"
if ! command_exists avidemux; then
	# https://www.fosshub.com/Avidemux.html
	# 2021-05-09
	sudo wget -q "https://download.fosshub.com/Protected/expiretime=1620645891;badurl=aHR0cHM6Ly93d3cuZm9zc2h1Yi5jb20vQXZpZGVtdXguaHRtbA==/f95d3bfc979272cdc6ebfb90f80401dfa79f5fb079446957d2a0e73524e35797/5b92987559eee027c3d78f03/60446dd53cca053a3f74a342/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage" -O /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage
	sudo chmod +x /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage

	if [ ! -f $HOME/.local/share/icons/avidemux_icon.png ]; then
		if [ ! -d $HOME/.local/share/icons ]; then
			mkdir -p $HOME/.local/share/icons
		fi
		wget -q https://raw.githubusercontent.com/mean00/avidemux2/master/avidemux_icon.png -O $HOME/.local/share/icons/avidemux_icon.png
	fi

	mkdir -p $HOME/.local/share/applications
	if [ ! -f $HOME/.local/share/applications/avidemux.desktop ]; then
		# https://specifications.freedesktop.org/menu-spec/menu-spec-1.0.html
		# https://specifications.freedesktop.org/menu-spec/menu-spec-1.0.html#category-registry
		cat >$HOME/.local/share/applications/avidemux.desktop <<EOL
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=2.7.8
Type=Application
Categories=AudioVideo;Audio;AudioVideoEditing;
Terminal=false
Icon=$HOME/.local/share/icons/avidemux_icon.png
Icon[fr_FR]=$HOME/.local/share/icons/avidemux_icon.png
Name[fr_FR]=Avidemux
Exec=/usr/local/bin/avidemux
Comment[fr_FR]=Editeur vidéo
Name=Avidemux
Comment=Editeur vidéo
EOL
	fi

	sudo ln -s /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage /usr/local/bin/avidemux
else
	echo "avidemux already installed -> SKIP"
fi

figlet "FFMPEG"
if ! command_exists ffmpeg; then
	sudo apt-get -y install ffmpeg
else
	echo "ffmpeg already installed -> SKIP"
fi

figlet "YOUTUBE-DL"
if ! command_exists youtube-dl; then
	if command_exists pipx; then
		pipx install youtube-dl
	else
		echo "YOUTUBE-DL - missing dependency: pipx - FAIL"
	fi
else
	echo "youtube-dl already installed -> SKIP"
fi

figlet "VLC"
! command_exists vlc && sudo apt-get -y install vlc

figlet "MPV"
! command_exists mpv && sudo apt-get -y install mpv

figlet "SPOTIFY"
if ! command_exists spotify; then
	curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
	if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
		echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	fi
	sudo apt-get update && sudo apt-get install -y spotify-client
else
	echo "spotify already installed -> SKIP"
fi

figlet "AUDACITY"
if ! command_exists audacity; then
	sudo apt-get -y install audacity audacity-data
else
	echo "audacity already installed -> SKIP"
fi

# Communication & New
#   _____                                      _           _   _                        _   _
#  / ____|                                    (_)         | | (_)               ___    | \ | |
# | |     ___  _ __ ___  _ __ ___  _   _ _ __  _  ___ __ _| |_ _  ___  _ __    ( _ )   |  \| | _____      _____
# | |    / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| |/ __/ _` | __| |/ _ \| '_ \   / _ \/\ | . ` |/ _ \ \ /\ / / __|
# | |___| (_) | | | | | | | | | | | |_| | | | | | (_| (_| | |_| | (_) | | | | | (_>  < | |\  |  __/\ V  V /\__ \
#  \_____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\___\__,_|\__|_|\___/|_| |_|  \___/\/ |_| \_|\___| \_/\_/ |___/
#
figlet "Brave"
if ! command_exists brave-browser; then
	sudo apt-get -y install apt-transport-https curl
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt-get update &&
		sudo apt-get -y install brave-browser
else
	echo "brave-broswer: skip"
fi

figlet "SIGNAL"
# https://www.signal.org/fr/download/#
if ! command_exists signal-desktop; then
	wget -q -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >signal-desktop-keyring.gpg
	sudo mv signal-desktop-keyring.gpg /usr/share/keyrings/
	if [ ! -f /etc/apt/sources.list.d/signal-xenial.list ]; then
		echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |
			sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
	fi
	sudo apt-get update && sudo apt-get -y install signal-desktop
fi

figlet "DISCORD"
if ! command_exists discord; then
	# APPIMAGE
	sudo wget -q "https://github.com/srevinsaju/discord-appimage/releases/download/canary/Discord-0.0.25-x86_64.AppImage" -O /usr/local/bin/Discord-0.0.25-x86_64.AppImage
	sudo chmod +x /usr/local/bin/Discord-0.0.25-x86_64.AppImage

	sudo ln -s /usr/local/bin/Discord-0.0.25-x86_64.AppImage /usr/local/bin/discord

	mkdir -p $HOME/.local/share/applications
	if [ ! -f $HOME/.local/share/applications/discord.desktop ]; then
		cat >$HOME/.local/share/applications/discord.desktop <<EOL
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=0.0.25
Type=Application
Categories=Network;InstantMessaging;
Terminal=false
Icon=$HOME/.local/share/icons/discord-icon.png
Icon[fr_FR]=$HOME/.local/share/icons/discord-icon.png
Name[fr_FR]=Discord
Exec=/usr/local/bin/discord
Comment[fr_FR]=
Name=Discord
Comment=
EOL
	fi
else
	echo "discord already installed -> SKIP"
fi

# TODO: change strategy to install this application (maybe AppImage)
# figlet "SLACK"
# if ! command_exists slack; then
# 	# https://slack.com/intl/fr-fr/downloads/linux
# 	wget -q https://downloads.slack-edge.com/linux_releases/slack-desktop-4.16.0-amd64.deb -O /tmp/slack-desktop-4.16.0-amd64.deb
# 	sudo dpkg -i /tmp/slack-desktop-4.16.0-amd64.deb
# else
# 	echo "slack already installed -> SKIP"
# fi

figlet "Video DownloadHelper Companion App"
if ! package_installed net.downloadhelper.coapp; then
	# https://www.downloadhelper.net/install-coapp?browser=chrome
	wget -q "https://github.com/mi-g/vdhcoapp/releases/download/v1.6.3/net.downloadhelper.coapp-1.6.3-1_amd64.deb" -O /tmp/net.downloadhelper.coapp-1.6.3-1_amd64.deb
	sudo dpkg -i /tmp/net.downloadhelper.coapp-1.6.3-1_amd64.deb
else
	echo "Video DownloadHelper Companion App already installed -> SKIP"
fi

figlet "LYNX"
! command_exists lynx && sudo apt-get -y install lynx

figlet "SHADOW"
if ! command_exists ShadowBeta.AppImage; then
	# https://nicolasguilloux.github.io/blade-shadow-beta/setup
	sudo apt-get install -y libva-wayland2 intel-media-va-driver-non-free
	# https://nicolasguilloux.github.io/blade-shadow-beta/issues#the-drirc-fix
	curl https://gitlab.com/NicolasGuilloux/shadow-live-os/raw/arch-master/airootfs/etc/drirc -o ~/.drirc
	if [ ! -f /usr/local/bin/ShadowBeta.AppImage ]; then
		# https://appimage.github.io/Shadow/
		sudo wget -q -L "https://update.shadow.tech/launcher/preprod/linux/ubuntu_18.04/ShadowBeta.AppImage" -O /usr/local/bin/ShadowBeta.AppImage
	fi
	sudo chmod +x /usr/local/bin/ShadowBeta.AppImage
	sudo sysctl -w kernel.unprivileged_userns_clone=1
	if [ ! -f /etc/sysctl.d/99-shadow.conf ]; then
		echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-shadow.conf
	fi
else
	echo "ShadowBeta.AppImage already installed -> SKIP"
fi

# Utilities
#  _    _ _   _ _ _ _   _
# | |  | | | (_) (_) | (_)
# | |  | | |_ _| |_| |_ _  ___  ___
# | |  | | __| | | | __| |/ _ \/ __|
# | |__| | |_| | | | |_| |  __/\__ \
#  \____/ \__|_|_|_|\__|_|\___||___/
#
figlet "Enpass"
if [ ! -f /opt/enpass/Enpass ]; then
	! grep "https://apt.enpass.io/" /etc/apt/sources.list && echo "deb https://apt.enpass.io/ stable main" | sudo tee -a /etc/apt/sources.list >/dev/null
	wget -q -O - https://apt.enpass.io/keys/enpass-linux.key | sudo apt-key add -
	sudo apt-get update && sudo apt-get -y install enpass
else
	echo "enpass: skip"
fi

figlet "ALACRITTY"
if ! command_exists alacritty; then
	# https://github.com/alacritty/alacritty/releases/tag/v0.4.2
	wget -q https://github.com/alacritty/alacritty/releases/download/v0.4.3/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb -O /tmp/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb
	sudo dpkg -i /tmp/Alacritty-v0.4.3-ubuntu_18_04_amd64.deb

	# Set Alacritty as Default Terminal Editor
	# https://gist.github.com/aanari/08ca93d84e57faad275c7f74a23975e6
	sudo update-alternatives --force --quiet --install /usr/bin/x-terminal-emulator x-terminal-emulator $(command -v alacritty) 50
	sudo update-alternatives --force --skip-auto --quiet --config x-terminal-emulator
else
	echo "alacritty: skip"
fi

figlet "REDSHIT"
! command_exists redshift && sudo apt-get -y install redshift redshift-gtk

# Graphics & Photography
#   _____                 _     _                     _____  _           _                              _
#  / ____|               | |   (_)            ___    |  __ \| |         | |                            | |
# | |  __ _ __ __ _ _ __ | |__  _  ___ ___   ( _ )   | |__) | |__   ___ | |_ ___   __ _ _ __ __ _ _ __ | |__  _   _
# | | |_ | '__/ _` | '_ \| '_ \| |/ __/ __|  / _ \/\ |  ___/| '_ \ / _ \| __/ _ \ / _` | '__/ _` | '_ \| '_ \| | | |
# | |__| | | | (_| | |_) | | | | | (__\__ \ | (_>  < | |    | | | | (_) | || (_) | (_| | | | (_| | |_) | | | | |_| |
#  \_____|_|  \__,_| .__/|_| |_|_|\___|___/  \___/\/ |_|    |_| |_|\___/ \__\___/ \__, |_|  \__,_| .__/|_| |_|\__, |
#                  | |                                                             __/ |         | |           __/ |
#                  |_|                                                            |___/          |_|          |___/
#
figlet "FLAMESHOT"
! command_exists flameshot && sudo apt-get -y install flameshot

# Window Manager
# __          ___           _                 __  __
# \ \        / (_)         | |               |  \/  |
#  \ \  /\  / / _ _ __   __| | _____      __ | \  / | __ _ _ __   __ _  __ _  ___ _ __
#   \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / / | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
#    \  /\  /  | | | | | (_| | (_) \ V  V /  | |  | | (_| | | | | (_| | (_| |  __/ |
#     \/  \/   |_|_| |_|\__,_|\___/ \_/\_/   |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|
#                                                                       __/ |
#                                                                      |___/
#
figlet "THEME: NORDIC"
if [ ! -d /usr/share/themes/Nordic-darker ]; then
	sudo mkdir -p /usr/share/themes/Nordic-darker
	sudo tar -xf /tmp/Nordic-darker.tar.xz -C /usr/share/themes
fi

figlet "ICONS: ZAFIRO"
if [ ! -d /usr/share/icons/Zafiro-Icons ]; then
	sudo mkdir -p /usr/share/icons/Zafiro-Icons
	# sudo tar -xf /tmp/Zafiro-Icons.tar.xz -C /usr/share/icons
fi

figlet "WALLPAPER"
ln -sf "$HOME/.local/share/wallpapers/Mate_M013_4K.png" "$HOME/.local/share/wallpapers/default.png"

# DCONF
#  _____   _____ ____  _   _ ______
# |  __ \ / ____/ __ \| \ | |  ____|
# | |  | | |   | |  | |  \| | |__
# | |  | | |   | |  | | . ` |  __|
# | |__| | |___| |__| | |\  | |
# |_____/ \_____\____/|_| \_|_|
#
figlet "DCONF"
! command_exists dconf && sudo apt-get -y install dconf-cli

# System
#   _____           _
#  / ____|         | |
# | (___  _   _ ___| |_ ___ _ __ ___
#  \___ \| | | / __| __/ _ \ '_ ` _ \
#  ____) | |_| \__ \ ||  __/ | | | | |
# |_____/ \__, |___/\__\___|_| |_| |_|
#          __/ |
#         |___/
#
figlet "🐳 DOCKER"
if ! command_exists docker; then
	# wget -q -O - https://get.docker.com/ | sh - >/dev/null

	# https://docs.docker.com/engine/install/debian/
	sudo apt-get -y install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --y --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  		$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	sudo apt-get update && sudo apt-get -y install docker-ce docker-ce-cli containerd.io
	#
	sudo usermod -aG docker $USER
else
	echo "docker already installed -> SKIP"
fi

figlet "🐳 DockerCompose"
if ! command_exists docker-compose; then
	sudo curl -s -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
else
	echo "docker-compose already installed -> SKIP"
fi

figlet "🐳 cTop"
if ! command_exists ctop; then
	echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
	wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add - >/dev/null
	sudo apt-get update >/dev/null
	sudo apt-get -y install docker-ctop
else
	echo "docker-ctop alread installed -> SKIP"
fi

figlet "VAGRANT"
if ! command_exists vagrant; then
	# https://www.vagrantup.com/downloads
	[ ! -f /tmp/vagrant_2.2.16_x86_64.deb ] && wget -q https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb -O /tmp/vagrant_2.2.16_x86_64.deb
	sudo dpkg -i /tmp/vagrant_2.2.16_x86_64.deb
else
	echo "vagrant already installed -> SKIP"
fi

figlet "VIRTUALBOX"
if ! command_exists virtualbox; then
	sudo apt-get -y install build-essential linux-headers-amd64
	cd /tmp
	wget https://download.virtualbox.org/virtualbox/6.1.22/VirtualBox-6.1.22-144080-Linux_amd64.run
	chmod +x VirtualBox-6.1.22-144080-Linux_amd64.run
	sudo ./VirtualBox-6.1.22-144080-Linux_amd64.run
	vboxversion=$(wget -qO - https://download.virtualbox.org/virtualbox/LATEST.TXT)
	sudo vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${vboxversion}.vbox-extpack
	yes | sudo vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${vboxversion}.vbox-extpack >/dev/null
	sudo usermod -aG vboxusers $USER
else
	echo "virtualbox already installed -> SKIP"
fi

# IDE
#  _____ _____  ______
# |_   _|  __ \|  ____|
#   | | | |  | | |__
#   | | | |  | |  __|
#  _| |_| |__| | |____
# |_____|_____/|______|
#
figlet "NEOVIM"
if ! command_exists nvim; then
	# https://vim.fisadev.com/
	sudo apt-get -y install \
		git curl python3-pip exuberant-ctags ack-grep \
		neovim
fi

figlet "FISADEV"
if [ ! -f $HOME/.config/nvim/init.vim ]; then
	# Enabling the Python 3 Provider
	sudo pip3 install pynvim flake8 pylint isort neovim​

	mkdir -p $HOME/.config/nvim/
	echo "download config.vim from fisadev ..."
	wget -q https://raw.github.com/fisadev/fisa-vim-config/v12.0.1/config.vim -O $HOME/.config/nvim/init.vim
fi

figlet "VSCODE"
if ! command_exists code; then
	sudo apt-get -y install software-properties-common apt-transport-https curl
	curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt-get update && sudo apt-get -y install code
else
	echo "vs code alread installed -> SKIP"
fi

if [ ! "$(code --list-extensions | grep 'Shan.code-settings-sync')" ]; then
	figlet "Shan.code-settings-sync"
	# https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management
	code --install-extension Shan.code-settings-sync
fi

figlet "PYCHARM"
if [ ! -f /opt/pycharm/bin/pycharm.sh ]; then
	curl -fsSL https://download.jetbrains.com/python/pycharm-professional-2021.1.1.tar.gz -o /tmp/pycharm-professional-2021.1.1.tar.gz
	sudo mkdir -p /opt/pycharm
	sudo tar --strip-components=1 -xzf /tmp/pycharm-professional-2021.1.1.tar.gz -C /opt/pycharm

	ln -s $(realpath bin/pycharm.sh) $HOME/.local/bin/.

	cat >$HOME/.local/share/applications/pycharm.desktop <<EOL
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=2021.1.1
Type=Application
Name=PyCharm
Icon=/opt/pycharm/bin/pycharm.png
Exec="/opt/pycharm/bin/pycharm.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOL
else
	echo "pycharm alread installed -> SKIP"
fi

# FONTS
#  ______ ____  _   _ _______ _____
# |  ____/ __ \| \ | |__   __/ ____|
# | |__ | |  | |  \| |  | | | (___
# |  __|| |  | | . ` |  | |  \___ \
# | |   | |__| | |\  |  | |  ____) |
# |_|    \____/|_| \_|  |_| |_____/
#
figlet "FONTS"
if [ $(fc-list | grep "Source Code Pro for Powerline" | wc -l) -eq 0 ]; then
	# Dependencies
	sudo apt-get -y install unzip

	# Install
	mkdir -p $HOME/.local/share/fonts
	cd $HOME/.local/share/fonts

	wget -q \
		https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete.ttf \
		-O "Source Code Pro for Powerline.otf"

	fc-cache -fv

	if [ $(fc-list | grep "Source Code Pro for Powerline" | wc -l) -eq 0 ]; then
		echo "FAILED ! 'Source Code Pro for Powerline' not found in available fonts for user !"
		exit 1
	fi
fi

# KEYBOARD
#  _  __________     ______   ____          _____  _____
# | |/ /  ____\ \   / /  _ \ / __ \   /\   |  __ \|  __ \
# | ' /| |__   \ \_/ /| |_) | |  | | /  \  | |__) | |  | |
# |  < |  __|   \   / |  _ <| |  | |/ /\ \ |  _  /| |  | |
# | . \| |____   | |  | |_) | |__| / ____ \| | \ \| |__| |
# |_|\_\______|  |_|  |____/ \____/_/    \_\_|  \_\_____/
#
# Set keyboard layout
L='fr' &&
	sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard &&
	sudo localectl set-x11-keymap $L

# NFS - SYNOLOGY
#  _   _  _____ ______             _______     ___   _  ____  _      ____   _______     __
# | \ | |/ ____|  ____|           / ____\ \   / / \ | |/ __ \| |    / __ \ / ____\ \   / /
# |  \| | (___ | |__     ______  | (___  \ \_/ /|  \| | |  | | |   | |  | | |  __ \ \_/ /
# | . ` |\___ \|  __|   |______|  \___ \  \   / | . ` | |  | | |   | |  | | | |_ | \   /
# | |\  |____) | |                ____) |  | |  | |\  | |__| | |___| |__| | |__| |  | |
# |_| \_|_____/|_|               |_____/   |_|  |_| \_|\____/|______\____/ \_____|  |_|
#
figlet "NFS"
sudo apt-get -y install nfs-common
# sh for loop
# https://www.shellscript.sh/loops.html
NAS_VOLUME="volume1"
NAS_IP="192.168.1.29"
HOST_MOUNT_ROOTDIR="/media/nas"
for nas_drive in downloads video tvshow 2018_HMX 2019_365TALENTS 2021_365Talents 2021_UNOWHY; do
	HOST_MOUNT_DIR="${HOST_MOUNT_ROOTDIR}/${NAS_VOLUME}/${nas_drive}"
	sudo mkdir -p "${HOST_MOUNT_DIR}"
	! grep -q "/${NAS_VOLUME}/${nas_drive}" /etc/fstab && echo "${NAS_IP}:/${NAS_VOLUME}/${nas_drive} ${HOST_MOUNT_DIR} nfs    defaults,user,nofail,x-systemd.device-timeout=1,noatime,intr 0 0" | sudo tee -a /etc/fstab
done
sudo mount -a

# POST-INIT
#  _____   ____   _____ _______   _____ _   _ _____ _______
# |  __ \ / __ \ / ____|__   __| |_   _| \ | |_   _|__   __|
# | |__) | |  | | (___    | |______| | |  \| | | |    | |
# |  ___/| |  | |\___ \   | |______| | | . ` | | |    | |
# | |    | |__| |____) |  | |     _| |_| |\  |_| |_   | |
# |_|     \____/|_____/   |_|    |_____|_| \_|_____|  |_|
#
[ -f $HOME/.post-init.sh ] && chmod +x $HOME/.post-init.sh

set +ex
