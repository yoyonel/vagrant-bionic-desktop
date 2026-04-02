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
test_command "ctop -v"
test_command "docker-compose --version"
test_command "vagrant --version"

# test_command "vboxmanage --version"

test_command "zsh --version"
test_command "command-not-found --version || true"

test_command "atop -V"
test_command "gotop --version"
test_command "htop --version"

test_command "git --version"
test_command "gita --version"
test_command "delta --version"
test_command "gh --version | head -n 1"
test_command "tig --version | head -n 1"
test_command "pre-commit --version"

test_command "curl --version | head -n 1 | awk '{print \$1, \$2}'"
test_command "wget --version | head -n 1"
test_command "figlet -v | head -n 3 | tail -1"
test_command "direnv --version"
test_command "tmux -V"
test_command "bc --version | head -n 1"
test_command "ranger --version | head -n 1"
test_command "fzf --version"
test_command "lsd --version"
test_command "autojump --version"
test_command "grc --version | head -n 1"
test_command "wal -v"
test_command "neofetch --version || true"
test_command "tree --version"
test_command "bat --version"
test_command "jq --version"
test_command "rg --version | head -n 1"
test_command "ag --version | head -n 1"
test_command "rsync --version | head -n 1"
test_command "tldr --version"
test_command "ncdu --version"
test_command "duf --version"
test_command "nmap --version | head -n 1"
test_command "speedtest --version | head -n 1"

test_command "mate-about --version"
test_command "systemctl show lightdm.service --no-page | grep 'SubState=' | cut -f2 -d="
test_command "flameshot --version | head -n 1"
test_command "alacritty --version"
test_command "redshift -V"

test_command "python --version"
test_command "pip --version"
test_command "pyenv --version"
test_command "pipx --version"
test_command "poetry --version"

test_command "nvim --version | head -n 1"
test_command "code --version | head -n 1"

test_command "ffmpeg -version | head -n 1"
test_command "youtube-dl --version"
test_command "vlc --version | head -n 1"
test_command "mpv --version | head -n 1"

test_command "cpu-x --version | head -n 1"
test_command "hardinfo --version | head -n 1"

test_command "brave-browser --version"
test_command "lynx --version | head -n 1"

test_command "flatpak list | grep 'Signal Desktop'"
test_command "flatpak list | grep 'teams-for-linux'"
test_command "flatpak list | grep 'spotify'"
test_command "flatpak list | grep 'Discord'"

# ── VirtualBox Guest Additions integrity checks ───────────────────────────────
# These tests verify that GA are installed, functional, and version-matched
# with the host. Run from the host via: vagrant_tests.sh
echo ""
echo "── VirtualBox Guest Additions ──────────────────────────────────────────"

# 1. VBoxService is present and responds
test_command "/usr/sbin/VBoxService --version"

# 2. GA version matches VBOX_HOST_VERSION (injected from host via env)
#    If not set, skip the comparison gracefully.
if [ -n "$VBOX_HOST_VERSION" ]; then
	GA_INSTALLED=$(/usr/sbin/VBoxService --version 2>/dev/null | sed 's/r.*//')
	if [ "$GA_INSTALLED" = "$VBOX_HOST_VERSION" ]; then
		echo -e "✅ GA version matches host VBox: ${GREEN}${GA_INSTALLED}${NC}"
	else
		echo -e "❌ GA version mismatch: guest=${RED}${GA_INSTALLED}${NC} host=${RED}${VBOX_HOST_VERSION}${NC}"
	fi
else
	echo "⚠️  VBOX_HOST_VERSION not set — skipping version match check"
fi

# 3. vboxadd service is active (kernel module loader + userspace tools)
#    Note: VBoxLinuxAdditions.run installs two units: vboxadd + vboxadd-service
test_command "systemctl is-active vboxadd"

# 4. Kernel module is loaded
test_command "lsmod | grep -q vboxguest && echo 'vboxguest module loaded'"

# 5. VBoxClient-all launch (provides resize/clipboard/seamless)
#    Check the process is running (started by i3 autostart)
test_command "pgrep -a VBoxClient | head -3"

# 6. xrandr confirms dynamic resize is available (VBoxVGA driver active)
test_command "DISPLAY=:0 xrandr | grep -q 'Virtual1 connected' && echo 'xrandr: Virtual1 connected (resize capable)'"
# set +e
