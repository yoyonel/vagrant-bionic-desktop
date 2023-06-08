#                    _ _                 __      ___     _
#     /\            | (_)         ___    \ \    / (_)   | |
#    /  \  _   _  __| |_  ___    ( _ )    \ \  / / _  __| | ___  ___
#   / /\ \| | | |/ _` | |/ _ \   / _ \/\   \ \/ / | |/ _` |/ _ \/ _ \
#  / ____ \ |_| | (_| | | (_) | | (_>  <    \  /  | | (_| |  __/ (_) |
# /_/    \_\__,_|\__,_|_|\___/   \___/\/     \/   |_|\__,_|\___|\___/
#
figlet "AVIDEMUX"
# if ! command_exists avidemux; then
# 	# https://www.fosshub.com/Avidemux.html
# 	# 2021-05-09
# 	sudo wget -q "https://download.fosshub.com/Protected/expiretime=1620645891;badurl=aHR0cHM6Ly93d3cuZm9zc2h1Yi5jb20vQXZpZGVtdXguaHRtbA==/f95d3bfc979272cdc6ebfb90f80401dfa79f5fb079446957d2a0e73524e35797/5b92987559eee027c3d78f03/60446dd53cca053a3f74a342/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage" -O /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage
# 	sudo chmod +x /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage

# 	if [ ! -f $HOME/.local/share/icons/avidemux_icon.png ]; then
# 		if [ ! -d $HOME/.local/share/icons ]; then
# 			mkdir -p $HOME/.local/share/icons
# 		fi
# 		wget -q https://raw.githubusercontent.com/mean00/avidemux2/master/avidemux_icon.png -O $HOME/.local/share/icons/avidemux_icon.png
# 	fi

# 	mkdir -p $HOME/.local/share/applications
# 	if [ ! -f $HOME/.local/share/applications/avidemux.desktop ]; then
# 		# https://specifications.freedesktop.org/menu-spec/menu-spec-1.0.html
# 		# https://specifications.freedesktop.org/menu-spec/menu-spec-1.0.html#category-registry
# 		cat >$HOME/.local/share/applications/avidemux.desktop <<EOL
# #!/usr/bin/env xdg-open
# [Desktop Entry]
# Version=2.7.8
# Type=Application
# Categories=AudioVideo;Audio;AudioVideoEditing;
# Terminal=false
# Icon=$HOME/.local/share/icons/avidemux_icon.png
# Icon[fr_FR]=$HOME/.local/share/icons/avidemux_icon.png
# Name[fr_FR]=Avidemux
# Exec=/usr/local/bin/avidemux
# Comment[fr_FR]=Editeur vidéo
# Name=Avidemux
# Comment=Editeur vidéo
# EOL
# 	fi

# 	sudo ln -s /usr/local/bin/avidemuxLinux_2.7.8_GLIBC_2.28_amd64.appImage /usr/local/bin/avidemux
# else
# 	echo "avidemux already installed -> SKIP"
# fi

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

# figlet "SPOTIFY"
# # FIX: problem avec l'idempotence de l'installation
# if false and ! command_exists spotify; then
# 	if [ ! -f /etc/apt/trusted.gpg.d/spotify.gpg ]; then
# 		# https://www.spotify.com/us/download/linux/
# 		curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
# 		# TODO: grep sur le motif avant d'insérer
# 		echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
# 	fi
# 	sudo apt-get update && sudo apt-get install -y spotify-client
# else
# 	echo "spotify already installed -> SKIP"
# fi

figlet "AUDACITY"
if ! command_exists audacity; then
	sudo apt-get -y install audacity audacity-data
else
	echo "audacity already installed -> SKIP"
fi
