#!/bin/zsh
# set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

test_command_silent() {
	eval "$@" >/dev/null && echo "✅ $@" || echo "❌ $@"
}

test_command() {
	OUTPUT="$(eval $@ 2>&1)"
	retVal=$?
	if [ $retVal -eq 0 ]; then
		echo -e "✅ $@: ${GREEN}$OUTPUT${NC}"
	else
		printf "❌ $@\n${RED}$OUTPUT${NC}\n"
	fi
}

test_command "docker info | grep 'Server Version'"
test_command_silent "docker ps"

test_command "vboxmanage --version"

test_command "atop -V"
test_command "gotop --version"
test_command "htop --version"

test_command "curl --version | head -n 1 | awk '{print \$1, \$2}'"
test_command "wget --version | head -n 1"
test_command "git --version"

test_command "mate-about --version"
test_command "systemctl show lightdm.service --no-page | grep 'SubState=' | cut -f2 -d="

test_command "python --version"

test_command "pyenv --version"
test_command "pipx --version"
test_command "poetry --version"

test_command "nvim --version | head -n 1"
test_command "code --version | head -n 1"

test_command "ffmpeg -version | head -n 1"
test_command "youtube-dl --version"
test_command "vlc --version | head -n 1"
test_command "mpv --version | head -n 1"

# set +e
