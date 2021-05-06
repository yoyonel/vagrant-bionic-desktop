# TODO

## [WEB] Video DownloadHelper

- https://chrome.google.com/webstore/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfk/related
- [Video DownloadHelper Companion App 1.6.3](https://www.downloadhelper.net/install-coapp?browser=chrome)
- [weh stands for WebExtensions Helper.](https://github.com/mi-g/weh)

## [APP] Wine

- https://linuxhint.com/installing_wine_debian_10/
- https://wiki.winehq.org/Debian

```sh
sudo dpkg --add-architecture i386
sudo apt-add-repository contrib
sudo apt-add-repository non-free
sudo apt install -y wine wine64 wine32 winbind winetricks
```

## [APP] Teams (Microsoft)

- https://www.microsoft.com/fr-fr/microsoft-teams/download-app#desktopAppDownloadregion

```sh
curl -fsSL https://go.microsoft.com/fwlink/p/?LinkID=2112886&clcid=0x40c&culture=fr-fr&country=FR -o /tmp/teams_amd64.deb
sudo dpkg -i /tmp/teams_amd64.deb
```

## [APP] Shadow (Béta)

`OS: Ubuntu 20.04.1 LTS (fossa-charmander-14 X53) x86_64`

```sh
# https://github.com/NicolasGuilloux/blade-shadow-beta
curl https://raw.githubusercontent.com/NicolasGuilloux/blade-shadow-beta/master/scripts/check_driver.sh | bash
# récupéré du discord: https://discordapp.com/channels/263324043153768449/582598998544744455/748505006378057749
curl https://gitlab.com/NicolasGuilloux/shadow-live-os/raw/arch-master/airootfs/etc/drirc -o ~/.drirc
```

## [SYS] auto-cpufreq

- https://github.com/AdnanHodzic/auto-cpufreq
- https://www.youtube.com/watch?v=QkYRpVEEIlg&ab_channel=AdnanHodzic
- https://doc.ubuntu-fr.org/tlp (peut être à desactiver)

```sh
cd /tmp
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq
sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install
systemctl status auto-cpufreq
```

## [CLI] Linux tools for check disk usage and folders size

[Linux tools for check disk usage and folders size](https://dev.to/insolita/linux-tools-for-check-disk-usage-and-folders-size-1ko2):

- https://github.com/bootandy/dust
- https://dev.yorhel.nl/ncdu
- https://github.com/muesli/duf
