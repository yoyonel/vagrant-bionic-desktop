#  _____  ____     _____ _________  _____  _  __
# |_   _||___ \   / ____|__   __  |/ __  \| |/ /
#   | |    __) | | (___    | |    `| |  | | ' /
#   | |   |__ <   \___ \   | |     | |  | |  <
#  _| |_  ___) |  ____) |  | |    _| |__| | . \
# |_____||____/  |_____/   |_|   |_|\____/|_|\_\
#
# Stack: i3 + Polybar + Kitty + Rofi

figlet "LIGHTDM"
# Install lightdm if not already present (e.g. minimal mode without MATE)
if ! command_exists lightdm; then
	sudo apt-get -y install lightdm lightdm-gtk-greeter
else
	echo "lightdm already installed -> SKIP"
fi

figlet "I3 TILING WM"
sudo apt-get -y install \
	i3 \
	i3lock \
	i3status

figlet "POLYBAR"
sudo apt-get -y install polybar

figlet "KITTY"
sudo apt-get -y install kitty

figlet "ROFI"
sudo apt-get -y install rofi

figlet "I3 TOOLS"
sudo apt-get -y install \
	feh \
	picom \
	dunst \
	lxappearance \
	xss-lock \
	pulseaudio-utils \
	flameshot \
	scrot \
	network-manager-gnome \
	xdotool \
	arandr \
	x11-xserver-utils

figlet "VBOX GUEST"
# VirtualBox Guest Additions — required for VBoxClient-all (resize/fullscreen)
#
# Strategy: download the ISO directly from Oracle CDN using the host VBox version
# injected by the Vagrantfile as $VBOX_VERSION. This guarantees an exact version
# match (guest GA == host VBox), avoiding the Debian-packaged ISO (7.0.6) mismatch.
#
# VBoxClient-all is called via exec in i3/config at session start.
# Idempotent: skipped if VBoxService version already matches $VBOX_VERSION.

GA_VERSION="${VBOX_VERSION:-7.0.6}"
GA_ISO_URL="https://download.virtualbox.org/virtualbox/${GA_VERSION}/VBoxGuestAdditions_${GA_VERSION}.iso"
GA_ISO_PATH="/tmp/VBoxGuestAdditions_${GA_VERSION}.iso"

INSTALLED_GA=$(VBoxService --version 2>/dev/null | sed 's/r.*//' || echo 'none')

if [ "$INSTALLED_GA" = "$GA_VERSION" ]; then
	echo "VBoxGuestAdditions ${GA_VERSION} already installed -> SKIP"
else
	echo "Installing VBoxGuestAdditions ${GA_VERSION} (currently: ${INSTALLED_GA})"

	# Build toolchain (headers for current kernel)
	sudo apt-get install -y \
		build-essential \
		linux-headers-$(uname -r)

	# Download ISO from Oracle CDN
	wget -q --show-progress -O "$GA_ISO_PATH" "$GA_ISO_URL"

	# Verify ISO is readable (basic sanity check — aborts if download was truncated)
	file "$GA_ISO_PATH" | grep -q 'ISO 9660' || { echo "ERROR: downloaded file is not a valid ISO"; exit 1; }

	# Mount + install
	sudo mkdir -p /mnt/ga-iso
	sudo mount -o loop "$GA_ISO_PATH" /mnt/ga-iso
	sudo /mnt/ga-iso/VBoxLinuxAdditions.run --nox11 || true
	sudo umount /mnt/ga-iso
	rm -f "$GA_ISO_PATH"

	# Enable services (VBoxLinuxAdditions.run does not enable them automatically)
	sudo systemctl enable vboxadd vboxadd-service 2>/dev/null || true

	# Post-install sanity check
	if /usr/sbin/VBoxService --version &>/dev/null; then
		echo "VBoxGuestAdditions installed: $(/usr/sbin/VBoxService --version)"
	else
		echo "WARNING: VBoxService not found after install — check kernel module"
	fi
fi

figlet "I3: DEFAULT SESSION"
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo bash -c 'printf "[Seat:*]\nuser-session=i3\n" > /etc/lightdm/lightdm.conf.d/10-i3.conf'

figlet "I3: CREATE CONFIG DIRS"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/polybar"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/rofi"
