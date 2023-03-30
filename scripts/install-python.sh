#  _______     _________ _    _  ____  _   _
# |  __ \ \   / /__   __| |  | |/ __ \| \ | |
# | |__) \ \_/ /   | |  | |__| | |  | |  \| |
# |  ___/ \   /    | |  |  __  | |  | | . ` |
# | |      | |     | |  | |  | | |__| | |\  |
# |_|      |_|     |_|  |_|  |_|\____/|_| \_|
#
figlet "PYTHON"
sudo apt-get -y install \
	python3-pip \
	python3-venv \
	python3-pip \
	python3-argcomplete \
	python-is-python3

figlet "PIPX"
! command_exists pipx && python3 -m pip install --user pipx
python3 -m pipx ensurepath
export PATH=$PATH:"$HOME/.local/bin"

figlet "PYENV"
# if ! command_exists pyenv; then
if [ ! -d $HOME/.pyenv ]; then
	# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
	# Python (dev) dependencies for installing python interpreters from sources	
	sudo apt-get install -y \
		make \
		build-essential \
		libssl-dev \
		zlib1g-dev \
		libbz2-dev \
		libreadline-dev \
		libsqlite3-dev \
		wget \
		curl \
		llvm \
		libncurses5-dev \
		libncursesw5-dev \
		xz-utils \
		tk-dev \
		libffi-dev \
		liblzma-dev
	if [ -d $HOME/.pyenv ]; then
		echo "$HOME/.pyenv exist by pyenv can't be found ! Maybe a problem in setting stage ..."
		rm -rf $HOME/.pyenv
	fi
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
