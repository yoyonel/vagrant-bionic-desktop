#  ______   ______ _____ _____ __  __      _    _   _ ____
# / ___\ \ / / ___|_   _| ____|  \/  |    / \  | \ | |  _ \
# \___ \\ V /\___ \ | | |  _| | |\/| |   / _ \ |  \| | | | |
#  ___) || |  ___) || | | |___| |  | |  / ___ \| |\  | |_| |
# |____/ |_| |____/ |_| |_____|_|  |_| /_/   \_\_| \_|____/

#  _____ ___   ___  _     ____
# |_   _/ _ \ / _ \| |   / ___|
#   | || | | | | | | |   \___ \
#   | || |_| | |_| | |___ ___) |
#   |_| \___/ \___/|_____|____/
figlet "💻 CPU-X"
if ! command_exists cpu-x; then
	sudo apt-get -y install cpu-x
else
	echo "cpu-x already installed -> SKIP"
fi

figlet "💻 HardInfo"
if ! command_exists hardinfo; then
	sudo apt-get -y install hardinfo
else
	echo "hardinfo already installed -> SKIP"
fi
