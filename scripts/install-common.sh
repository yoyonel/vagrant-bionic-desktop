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
