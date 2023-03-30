########################
#  _____ _____ _______
#  / ____|_   _|__   __|
# | |  __  | |    | |
# | | |_ | | |    | |
# | |__| |_| |_   | |
#  \_____|_____|  |_|
#
########################
figlet "PRE-COMMIT"
if ! command_exists pre-commit; then
	if command_exists pipx; then
		pipx install pre-commit
	else
		echo "PRE-COMMIT - missing dependency: pipx - FAIL"
	fi
else
	echo "pre-commit already installed -> SKIP"
fi

figlet "TIG"
! command_exists tig && sudo apt-get -y install tig

figlet "GitHub cli"
if ! command_exists gh; then
	# https://github.com/cli/cli/releases
	wget -q https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_linux_amd64.deb -O /tmp/gh_1.11.0_linux_amd64.deb
	sudo dpkg -i /tmp/gh_1.11.0_linux_amd64.deb
else
	echo "github cli already installed -> SKIP"
fi

figlet "DELTA-DIFF"
if ! command_exists delta; then
	# https://github.com/dandavison/delta/releases
	wget -q https://github.com/barnumbirr/delta-debian/releases/download/0.6.0-1/delta-diff_0.6.0-1_amd64_debian_buster.deb -O /tmp/delta-diff_0.6.0-1_amd64_debian_buster.deb
	sudo dpkg -i /tmp/delta-diff_0.6.0-1_amd64_debian_buster.deb
else
	echo "delta-diff already installed -> SKIP"
fi

figlet "GITA"
if ! command_exists gita; then
	# https://github.com/nosarthur/gita
	pip3 install -U gita
	mkdir -p $HOME/.config/gita
	curl -fsSL https://raw.githubusercontent.com/nosarthur/gita/master/.gita-completion.zsh -o $HOME/.config/gita/.gita-completion.zsh
else
	echo "gita already installed -> SKIP"
fi
