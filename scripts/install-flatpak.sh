#  _____ _       _               _
# |  ___| | __ _| |_ _ __   __ _| | __
# | |_  | |/ _` | __| '_ \ / _` | |/ /
# |  _| | | (_| | |_| |_) | (_| |   <
# |_|   |_|\__,_|\__| .__/ \__,_|_|\_\
#                   |_|
figlet "FlatPak"
if ! command_exists flatpak; then
	# https://flatpak.org/setup/Debian
	sudo apt-get install -y flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# sudo shutdown -r now
else
	sudo flatpak update -y
	echo "flatpak: skip"
fi
