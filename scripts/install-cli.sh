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
if ! command_exists direnv; then
	sudo apt-get install -y direnv
fi

figlet "TMUX"
if ! command_exists tmux; then
	sudo apt install -y tmux
else
	echo "TMUX already installed -> SKIP"
fi
# bc: use by tmux-plugins/tmux-docker
if ! command_exists bc; then
	sudo apt-get -y install bc
else
	echo "BC already installed -> SKIP"
fi

if [ ! -f "$HOME/.tmux/.tmux.conf" ]; then
	git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
fi
if [ ! -f "$HOME/.tmux.conf" ]; then
	ln -sf .tmux/.tmux.conf .
	cp .tmux/.tmux.conf.local .
fi
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	figlet "TMUX-PLUGINS"
	git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

figlet "RANGER"
# ranger: Console file manager with VI key bindings.
# https://www.linuxfordevices.com/tutorials/linux/ranger-file-manager
if ! command_exists ranger; then
	sudo apt-get -y install ranger
else
	echo "ranger alread installer -> SKIP"
fi

figlet "FZF"
# TODO: ne plus passer par apt pour l'install ça semble bugger pour l'historique
# préférer un clone du répo et installation des binaires
# ou un download/install d'une release binaire
if ! command_exists fzf; then
	sudo apt-get -y install fzf
fi

figlet "LSD"
if ! command_exists lsd; then
	# https://github.com/Peltoche/lsd
	# wget -q https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -O /tmp/lsd_0.20.1_amd64.deb
	# sudo dpkg -i /tmp/lsd_0.20.1_amd64.deb
	sudo apt-get install -y lsd
else
	echo "lsd already installed => SKIP"
fi

figlet "AUTOJUMP"
if ! command_exists autojump; then
	sudo apt-get -y install autojump
fi

figlet "GRC"
if ! command_exists grc; then
	sudo apt-get -y install grc
fi

figlet "PYWAL"
if ! command_exists wal; then
	sudo apt-get -y install imagemagick
	pipx install pywal
else
	echo "pywal already installed -> SKIP"
fi

figlet "NEOFETCH"
if ! command_exists neofetch; then
	sudo apt-get -y install neofetch
fi

figlet "MOST"
if ! command_exists most; then
	sudo apt-get -y install most
fi

figlet "TREE"
if ! command_exists tree; then
	sudo apt-get -y install tree
fi

figlet "X[CLIP&SEL]"
if ! command_exists xclip; then
	sudo apt-get -y install xclip xsel
fi

figlet "BAT"
if ! command_exists bat; then
	wget -q https://github.com/sharkdp/bat/releases/download/v0.18.0/bat_0.18.0_amd64.deb -O /tmp/bat_0.18.0_amd64.deb
	sudo dpkg -i /tmp/bat_0.18.0_amd64.deb
else
	echo "bat already installed -> SKIP"
fi

figlet "JQ"
if ! command_exists jq; then
	sudo apt-get -y install jq
fi

figlet "RIPGREP"
# ripgrep recursively searches directories for a regex pattern
if ! command_exists rg; then
	sudo apt-get -y install ripgrep
fi

figlet "SILVERSEARCHER-AG"
# A code searching tool similar to ack, with a focus on speed.
# (ack is a code-searching tool, similar to grep but optimized for programmers searching large trees of source code.)
if ! command_exists ag; then
	sudo apt-get -y install silversearcher-ag
fi

figlet "RSYNC"
if ! command_exists rsync; then
	sudo apt-get -y install rsync
fi

figlet "TLDR"
if ! command_exists tldr; then
	sudo apt-get -y install tldr
fi

tldr tldr >/dev/null

figlet "NCDU"
# https://dev.yorhel.nl/ncdu
if ! command_exists ncdu; then
	sudo apt-get -y install ncdu
fi

figlet "DUF"
# https://github.com/muesli/duf
if ! command_exists duf; then
	# snap installation
	if command_exists snap; then
		sudo snap install duf-utility
	else
		sudo apt-get install -y duf
	fi
fi

figlet "NMAP"
if ! command_exists nmap; then
	sudo apt-get -y install nmap
fi

figlet "MONITORING"
# dnsutils -> dig: DNS Lookup utility
# net-tools -> netstat: Displays network-related information such as open connections, open socket ports, etc.
# glances: E: Unable to locate package glances
# atop: Linux system and process monitor.More information: https://manned.org/atop.
sudo apt-get -y install \
	htop \
	iotop \
	bmon \
	net-tools \
	dnsutils \
	atop

figlet "GOTOP"
if ! command_exists gotop; then
	# if [ ! -d "/tmp/gotop" ]; then
	# 	git clone --depth 1 https://github.com/cjbassi/gotop /tmp/gotop
	# fi
	# bash /tmp/gotop/scripts/download.sh
	# sudo mv gotop /usr/local/bin

	# TODO: find a way to get the last release
	# [https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8](One Liner to Download the Latest Release from Github Repo)
	# https://github.com/xxxserxxx/gotop/releases
	wget -q "https://github.com/xxxserxxx/gotop/releases/download/v4.2.0/gotop_v4.2.0_linux_amd64.deb" \
		-O "/tmp/gotop_v4.2.0_linux_amd64.deb"
	sudo dpkg -i "/tmp/gotop_v4.2.0_linux_amd64.deb"
fi

figlet "SPEEDTEST"
if ! command_exists speedtest; then
	# https://www.speedtest.net/apps/cli
	curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
	sudo apt-get -y install speedtest
else
	echo "speedtest already installed -> SKIP"
fi

figlet "PARALLEL"
# need `parallel` from parallel package not from more-utils
sudo apt-get -y install parallel
