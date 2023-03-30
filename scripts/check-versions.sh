#!/bin/zsh
# set -e

test_command_silent() {
	eval "$@" >/dev/null && echo "✅ $@" || echo "❌ $@"
}

test_command() {
	result_cmd=$(eval "$@")
	retVal=$?
	if [ $retVal -eq 0 ]; then
		echo -e "✅ $@: $result_cmd"
	else
		echo -e "❌ $@"
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

# set +e
