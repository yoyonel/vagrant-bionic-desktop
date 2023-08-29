#   _____           _
#  / ____|         | |
# | (___  _   _ ___| |_ ___ _ __ ___
#  \___ \| | | / __| __/ _ \ '_ ` _ \
#  ____) | |_| \__ \ ||  __/ | | | | |
# |_____/ \__, |___/\__\___|_| |_| |_|
#          __/ |
#         |___/
#
figlet "🐳 DOCKER"
if ! command_exists docker; then
	# wget -q -O - https://get.docker.com/ | sh - >/dev/null

	# https://docs.docker.com/engine/install/debian/
	sudo apt-get -y install \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --y --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
		$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
	# sudo rm -rf /var/lib/apt/lists/*
	sudo apt-get update && sudo apt-get -y install docker-ce docker-ce-cli containerd.io
	#
	sudo usermod -aG docker $USER
else
	echo "docker already installed -> SKIP"
fi

figlet "🐳 DockerCompose"
if ! command_exists docker-compose; then
	sudo curl -s -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
else
	echo "docker-compose already installed -> SKIP"
fi

figlet "🐳 cTop"
# TODO: https://github.com/veggiemonk/awesome-docker/blob/master/README.md#terminal
if ! command_exists ctop; then
	# https://github.com/bcicen/ctop#debianubuntu
	sudo apt-get install ca-certificates curl gnupg lsb-release
	curl -fsSL https://azlux.fr/repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/azlux-archive-keyring.gpg
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian \
	$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azlux.list >/dev/null
	sudo apt-get update > /dev/null
	sudo apt-get install docker-ctop
else
	echo "docker-ctop alread installed -> SKIP"
fi

figlet "VAGRANT"
if ! command_exists vagrant; then
	# https://www.vagrantup.com/downloads
	[ ! -f /tmp/vagrant_2.2.16_x86_64.deb ] && wget -q https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb -O /tmp/vagrant_2.2.16_x86_64.deb
	sudo dpkg -i /tmp/vagrant_2.2.16_x86_64.deb
else
	echo "vagrant already installed -> SKIP"
fi
