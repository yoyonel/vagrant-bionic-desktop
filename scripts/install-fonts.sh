#  ______ ____  _   _ _______ _____
# |  ____/ __ \| \ | |__   __/ ____|
# | |__ | |  | |  \| |  | | | (___
# |  __|| |  | | . ` |  | |  \___ \
# | |   | |__| | |\  |  | |  ____) |
# |_|    \____/|_| \_|  |_| |_____/
#"PYC
figlet "FONTS"
if [ $(fc-list | grep "Source Code Pro for Powerline" | wc -l) -eq 0 ]; then
	# Dependencies
	sudo apt-get -y install unzip

	# Install
	mkdir -p $HOME/.local/share/fonts

	wget \
		https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/SourceCodePro/Regular/SauceCodeProNerdFont-Regular.ttf \
		-O "$HOME/.local/share/fonts/Source Code Pro for Powerline.otf"

	fc-cache -fv

	if [ $(fc-list | grep "Source Code Pro for Powerline" | wc -l) -eq 0 ]; then
		echo "FAILED ! 'Source Code Pro for Powerline' not found in available fonts for user !"
		exit 1
	fi
fi
