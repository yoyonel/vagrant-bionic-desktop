# [https://serverfault.com/a/670688](dpkg-reconfigure: unable to re-open stdin: No file or directory)
export DEBIAN_FRONTEND=noninteractive

# https://askubuntu.com/a/1107071
# http://manpages.ubuntu.com/manpages/xenial/en/man5/apt.conf.5.html
# sudo sh -c "echo 'APT::Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries"

# sudo rm -rf /var/lib/apt/lists/*
# sudo apt-get clean
# # https://www.appsloveworld.com/docker/100/105/how-to-fix-hash-sum-mismatch-in-docker-on-mac
# sudo apt-get update -o Acquire::CompressionTypes::Order::=gz
sudo apt-get clean && sudo apt-get update

# Figlet
if ! command_exists figlet; then
	sudo apt-get -y install figlet
else
	echo "figlet already installed -> SKIP"
fi
