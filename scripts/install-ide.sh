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
		git curl python3-pip exuberant-ctags ack-grep neovim
fi

figlet "FISADEV"
if [ ! -f $HOME/.config/nvim/init.vim ]; then
	# Enabling the Python 3 Provider
	# pipx install pynvim flake8 pylint isort
	#
	# [Allow to install multiple packages #88](https://github.com/pypa/pipx/issues/88#issuecomment-1482693600)
	# https://www.cyberciti.biz/faq/linux-unix-bash-for-loop-one-line-command/
	# for p in pynvim flake8 pylint isort; do pipx install $p; done

	sudo apt-get install -y \
		python3-pynvim \
		python3-flake8 \
		pylint \
		python3-isort

	mkdir -p $HOME/.config/nvim/
	echo "download config.vim from fisadev ..."
	wget -q https://raw.github.com/fisadev/fisa-vim-config/v12.0.1/config.vim -O $HOME/.config/nvim/init.vim
fi

figlet "VSCODE"
if ! command_exists code; then
	sudo apt-get -y install software-properties-common apt-transport-https curl
	curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	# sudo rm -rf /var/lib/apt/lists/*
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
# FIXME: Too long to install ...
if false and [ ! -f /opt/pycharm/bin/pycharm.sh ]; then
	curl -fsSL https://download.jetbrains.com/python/pycharm-professional-2021.1.1.tar.gz -o /tmp/pycharm-professional-2021.1.1.tar.gz
	sudo mkdir -p /opt/pycharm
	sudo tar --strip-components=1 -xzf /tmp/pycharm-professional-2021.1.1.tar.gz -C /opt/pycharm

	ln -s $(realpath /opt/pycharm/bin/pycharm.sh) $HOME/.local/bin/.

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
