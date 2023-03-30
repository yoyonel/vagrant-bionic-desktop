figlet "VIRTUALBOX"

if ! command_exists virtualbox; then
	# https://linuxiac.com/how-to-install-virtualbox-on-debian-11-bullseye/
	wget -O- -q https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmour -o /usr/share/keyrings/oracle_vbox_2016.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle_vbox_2016.gpg] http://download.virtualbox.org/virtualbox/debian bullseye contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

	sudo apt-get update
	sudo apt-get install -y virtualbox-6.1

	vboxversion=$(vboxmanage -v | cut -dr -f1)
	# vboxversion="6.1.22"
	wget -q "https://download.virtualbox.org/virtualbox/${vboxversion}/Oracle_VM_VirtualBox_Extension_Pack-${vboxversion}.vbox-extpack"
	yes | sudo vboxmanage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-${vboxversion}.vbox-extpack >/dev/null
	sudo usermod -aG vboxusers $USER
else
	echo "virtualbox already installed -> SKIP"
fi
