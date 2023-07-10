#   _____                                      _           _   _                        _   _
#  / ____|                                    (_)         | | (_)               ___    | \ | |
# | |     ___  _ __ ___  _ __ ___  _   _ _ __  _  ___ __ _| |_ _  ___  _ __    ( _ )   |  \| | _____      _____
# | |    / _ \| '_ ` _ \| '_ ` _ \| | | | '_ \| |/ __/ _` | __| |/ _ \| '_ \   / _ \/\ | . ` |/ _ \ \ /\ / / __|
# | |___| (_) | | | | | | | | | | | |_| | | | | | (_| (_| | |_| | (_) | | | | | (_>  < | |\  |  __/\ V  V /\__ \
#  \_____\___/|_| |_| |_|_| |_| |_|\__,_|_| |_|_|\___\__,_|\__|_|\___/|_| |_|  \___/\/ |_| \_|\___| \_/\_/ |___/
#
figlet "Brave"
if ! command_exists brave-browser; then
	# https://brave.com/linux/#debian-ubuntu-mint
	sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg	
	echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
	sudo apt-get update && \
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
	# sudo rm -rf /var/lib/apt/lists/*
	sudo apt-get update && sudo apt-get -y install signal-desktop
fi

figlet "DISCORD"
if false and ! command_exists discord; then
	# FIX: can't download the Appimage !
	# APPIMAGE
	# + sudo wget -q https://github.com/srevinsaju/discord-appimage/releases/download/stable/Discord-0.0.17-x86_64.AppImage -O /usr/local/bin/Discord-0.0.25-x86_64.AppImage
	# user@debian:~/vagrant-bionic-desktop$ echo $?
	# 8
	# sudo wget -q "https://github.com/srevinsaju/discord-appimage/releases/download/stable/Discord-0.0.17-x86_64.AppImage" -O /usr/local/bin/Discord-0.0.25-x86_64.AppImage
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
if ! command_exists lynx; then
	sudo apt-get -y install lynx
else
	echo "LYNX already installed -> SKIP"
fi

# figlet "SHADOW"
# if ! command_exists ShadowBeta.AppImage; then
# 	# https://nicolasguilloux.github.io/blade-shadow-beta/setup
# 	sudo apt-get install -y libva-wayland2 intel-media-va-driver-non-free
# 	# https://nicolasguilloux.github.io/blade-shadow-beta/issues#the-drirc-fix
# 	curl https://gitlab.com/NicolasGuilloux/shadow-live-os/raw/arch-master/airootfs/etc/drirc -o ~/.drirc
# 	if [ ! -f /usr/local/bin/ShadowBeta.AppImage ]; then
# 		# https://appimage.github.io/Shadow/
# 		sudo wget -q -L "https://update.shadow.tech/launcher/preprod/linux/ubuntu_18.04/ShadowBeta.AppImage" -O /usr/local/bin/ShadowBeta.AppImage
# 	fi
# 	sudo chmod +x /usr/local/bin/ShadowBeta.AppImage
# 	sudo sysctl -w kernel.unprivileged_userns_clone=1
# 	if [ ! -f /etc/sysctl.d/99-shadow.conf ]; then
# 		echo "kernel.unprivileged_userns_clone=1" | sudo tee /etc/sysctl.d/99-shadow.conf
# 	fi
# else
# 	echo "ShadowBeta.AppImage already installed -> SKIP"
# fi
