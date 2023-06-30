#  _____   _____ ____  _   _ ______
# |  __ \ / ____/ __ \| \ | |  ____|
# | |  | | |   | |  | |  \| | |__
# | |  | | |   | |  | | . ` |  __|
# | |__| | |___| |__| | |\  | |
# |_____/ \_____\____/|_| \_|_|
#
figlet "DCONF"
if ! command_exists dconf; then
	sudo apt-get -y install dconf-cli
else
	echo "dconf already installed -> SKIP"
fi
