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
# Uses the Debian-packaged ISO (contrib/non-free) + compiles via DKMS.
# VBoxClient-all is called via exec in i3/config at session start.
if ! /usr/sbin/VBoxService --version &>/dev/null; then
	sudo apt-get install -y \
		virtualbox-guest-additions-iso \
		build-essential \
		linux-headers-$(uname -r)
	sudo mkdir -p /mnt/ga-iso
	sudo mount -o loop /usr/share/virtualbox/VBoxGuestAdditions.iso /mnt/ga-iso
	sudo /mnt/ga-iso/VBoxLinuxAdditions.run --nox11 || true
	sudo umount /mnt/ga-iso
else
	echo "VBoxGuestAdditions already installed -> SKIP"
fi

figlet "I3: DEFAULT SESSION"
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo bash -c 'printf "[Seat:*]\nuser-session=i3\n" > /etc/lightdm/lightdm.conf.d/10-i3.conf'

figlet "I3: CREATE CONFIG DIRS"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/polybar"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/rofi"
