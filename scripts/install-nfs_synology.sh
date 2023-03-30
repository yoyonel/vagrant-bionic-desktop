#  _   _  _____ ______             _______     ___   _  ____  _      ____   _______     __
# | \ | |/ ____|  ____|           / ____\ \   / / \ | |/ __ \| |    / __ \ / ____\ \   / /
# |  \| | (___ | |__     ______  | (___  \ \_/ /|  \| | |  | | |   | |  | | |  __ \ \_/ /
# | . ` |\___ \|  __|   |______|  \___ \  \   / | . ` | |  | | |   | |  | | | |_ | \   /
# | |\  |____) | |                ____) |  | |  | |\  | |__| | |___| |__| | |__| |  | |
# |_| \_|_____/|_|               |_____/   |_|  |_| \_|\____/|______\____/ \_____|  |_|
#
figlet "NFS"
sudo apt-get -y install nfs-common
# sh for loop
# https://www.shellscript.sh/loops.html
if false; then
	NAS_VOLUME="volume1"
	NAS_IP="192.168.1.29"
	HOST_MOUNT_ROOTDIR="/media/nas"
	for nas_drive in downloads video tvshow 2018_HMX 2019_365TALENTS 2021_365Talents 2021_UNOWHY; do
		HOST_MOUNT_DIR="${HOST_MOUNT_ROOTDIR}/${NAS_VOLUME}/${nas_drive}"
		sudo mkdir -p "${HOST_MOUNT_DIR}"
		! grep -q "/${NAS_VOLUME}/${nas_drive}" /etc/fstab && echo "${NAS_IP}:/${NAS_VOLUME}/${nas_drive} ${HOST_MOUNT_DIR} nfs    defaults,user,nofail,x-systemd.device-timeout=1,noatime,intr 0 0" | sudo tee -a /etc/fstab
	done
	sudo mount -a
fi
