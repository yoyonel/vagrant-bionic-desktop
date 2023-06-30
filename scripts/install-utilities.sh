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
	# sudo rm -rf /var/lib/apt/lists/*
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
if ! command_exists redshift; then
	sudo apt-get update
	sudo apt-get -y install redshift redshift-gtk
fi
