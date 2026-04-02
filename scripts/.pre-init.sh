# [https://serverfault.com/a/670688](dpkg-reconfigure: unable to re-open stdin: No file or directory)
export DEBIAN_FRONTEND=noninteractive

# Suppress "dpkg-preconfigure: unable to re-open stdin" in Vagrant non-interactive sessions
# dpkg-preconfigure is called by apt before unpacking but stdin is closed — disable it
sudo sh -c 'echo "DPkg::Pre-Install-Pkgs {};" > /etc/apt/apt.conf.d/70disable-dpkg-preconfigure'

# https://askubuntu.com/a/1107071
# http://manpages.ubuntu.com/manpages/xenial/en/man5/apt.conf.5.html
# sudo sh -c "echo 'APT::Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries"

# sudo rm -rf /var/lib/apt/lists/*
# sudo apt-get clean
# # https://www.appsloveworld.com/docker/100/105/how-to-fix-hash-sum-mismatch-in-docker-on-mac
# sudo apt-get update -o Acquire::CompressionTypes::Order::=gz

# ── Clock sync ────────────────────────────────────────────────────────────
# VirtualBox VMs often start with a drifted clock, causing TLS certificate
# verification failures ("certificate name mismatch") on apt HTTPS sources.
#
# hwclock --hctosys: immediate, no network needed.
# VirtualBox keeps the hardware clock in sync with the host OS.
sudo hwclock --hctosys 2>/dev/null || true
echo "hwclock -> system clock applied: $(date)"
#
# Start NTP in background for long-term accuracy (non-blocking)
sudo timedatectl set-ntp true
sudo systemctl enable --now systemd-timesyncd 2>/dev/null || true
# ─────────────────────────────────────────────────────────────────────────

# Enable contrib + non-free — required for virtualbox-guest-additions-iso
# (needed for VBoxClient-all to provide dynamic screen resize in VM)
sudo sed -i 's/^deb https:\/\/deb.debian.org\/debian bookworm main$/deb https:\/\/deb.debian.org\/debian bookworm main contrib non-free non-free-firmware/' /etc/apt/sources.list

sudo apt-get clean && sudo apt-get update

# Nala — parallel package downloads (replaces apt-get install transparently)
# https://gitlab.com/volian/nala
if ! command_exists nala; then
	sudo /usr/bin/apt-get -y install nala
fi

# Wrapper: redirect 'sudo apt-get install' -> 'nala install' (parallel downloads)
# /usr/local/sbin has priority over /usr/bin in sudo's secure_path on Debian
if command_exists nala && [ ! -f /usr/local/sbin/apt-get ]; then
	sudo tee /usr/local/sbin/apt-get > /dev/null <<'WRAPPER'
#!/bin/bash
# Transparent wrapper: use nala for parallel installs, real apt-get otherwise
if [[ "$1" == "install" ]]; then
    exec /usr/bin/nala install "${@:2}"
else
    exec /usr/bin/apt-get "$@"
fi
WRAPPER
	sudo chmod +x /usr/local/sbin/apt-get
	echo "nala wrapper installed -> apt-get install now uses nala"
fi

# Figlet
if ! command_exists figlet; then
	sudo /usr/bin/apt-get -y install figlet
else
	echo "figlet already installed -> SKIP"
fi
