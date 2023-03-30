figlet "DESKTOP"
figlet "MATE+LIGHTDM"
# Optional: Use LightDM login screen (-> not required to run "startx")
# https://github.com/mate-desktop/mate-system-monitor
# https://github.com/mate-desktop/mate-applets
# https://ubuntu-mate.community/t/how-to-remove-home-folder-from-desktop/498/9
sudo apt-get -y install \
	mate-core \
	mate-system-monitor \
	mate-system-monitor-common \
	mate-applets \
	mate-applets-common \
	mate-tweak \
	lightdm \
	lightdm-gtk-greeter
