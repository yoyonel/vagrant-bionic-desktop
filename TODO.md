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

- [Flathub.org - teams-for-linux](https://flathub.org/fr/apps/com.github.IsmaelMartinez.teams_for_linux)

```sh
# Installation manuelle
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux

# Exécuter
flatpak run com.github.IsmaelMartinez.teams_for_linux
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

---

[2023-03-23]

Use bash instead of zsh on low profile laptop/netbook
- use [oh-my-bash](https://github.com/ohmybash/oh-my-bash) to enhance the experience ^^
- add to `$HOME/.bashrc` some options/settings
    - update `PATH`:
        ```shell
        # to access to (for example) `wal`
        export PATH="$PATH:$HOME/.local/bin"
        ```
    - `pipx`
        ```shell
        # pipx
        # from: `pipx completions` (command)
        eval "$(register-python-argcomplete pipx)"
        ```
    - `lsd`: https://github.com/lsd-rs/lsd#optional
    - `fzf`
        ```shell
        # FZF
        export FZF_DEFAULT_OPTS='--preview "bat --style=numbers --color=always --line-range :500 {}"'
        [ -f ~/.fzf.bash ] && source ~/.fzf.bash
        ```
    - `autojump`
        ```shell
        # Autojump
        . /usr/share/autojump/autojump.sh
        ```
    - `wal`
        ```shell
        # PyWal
        # https://github.com/dylanaraps/pywal/wiki/Getting-Started#applying-the-theme-to-new-terminals
        [ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)
        # -R restores the last colorscheme that was in use.
        wal -q -n -R >/dev/null
        ```
    - `ctop`
        ```shell
        # [Move away from termbox, tmux compatibility #263](https://github.com/bcicen/ctop/issues/263)
        alias ctop='TERM="${TERM/#tmux/screen}" ctop'
        ```
- update `.tmux.conf.local` to set `bash` as default **Tmux shell** 

Regarder cet utilitaire de remplacement de `find` qui semble assez cool: [A simple, fast and user-friendly alternative to 'find'](https://github.com/sharkdp/fd)

Il y a un bug pour la mise en place des icones `Zafiro-Icons [GTK2/3]`, il faut revoir la procédure d'installation/settings.
Après fix, on doit avoir une gestion des icones et `neofetch` qui affiche:
```shell
02:13:59 user@debian ~ → neofetch -A
       _,met$$$$$gg.          user@debian
    ,g$$$$$$$$$$$$$$$P.       -----------
  ,g$$P"     """Y$$.".        OS: Debian GNU/Linux 11 (bullseye) x86_64
 ,$$P'              `$$$.     Host: Easynote ENTG71BM V1.07
',$$P       ,ggs.     `$$b:   Kernel: 5.10.0-20-amd64
`d$$'     ,$P"'   .    $$$    Uptime: 4 hours, 8 mins
 $$P      d$'     ,    $$P    Packages: 2513 (dpkg)
 $$:      $$.   -    ,d$$'    Shell: bash 5.1.4
 $$;      Y$b._   _,d$P'      Resolution: 1366x768
 Y$$.    `.`"Y$$$$P"'         DE: MATE 1.24.1
 `$$b      "-.__              WM: Metacity (Marco)
  `Y$$                        Theme: Nordic-darker [GTK2/3]
   `Y$$.                      Icons: Zafiro-Icons [GTK2/3]
     `$$b.                    CPU: Intel Celeron N2940 (4) @ 1.832GHz
       `Y$$b.                 GPU: Intel Atom Processor Z36xxx/Z37xxx Series Graphics & Display
          `"Y$b._             Memory: 1686MiB / 3812MiB
              `"""
```

TODO: lire et intégrer les outils de monitoring de cet article [30 Linux System Monitoring Tools Every SysAdmin Should Know](https://www.cyberciti.biz/tips/top-linux-monitoring-tools.html)

Regarder pour installer/set `nala`: [Nala is a front-end for libapt-pkg. Specifically we interface using the python-apt api.
](https://gitlab.com/volian/nala/-/tree/main#installation)
- [nala > Wiki > Installation](https://gitlab.com/volian/nala/-/wikis/Installation): installé depuis les sources
```shell
→ git clone https://gitlab.com/volian/nala.git
→ cd nala
→ sudo apt install git python3-apt python3-debian pandoc -y
→ sudo make install
→ nala --version
nala 0.12.3
```

[A curated list of Docker resources and projects](https://github.com/veggiemonk/awesome-docker/blob/master/README.md#terminal)
- [A tool for exploring a docker image, layer contents, and discovering ways to shrink the size of your Docker/OCI image.](https://github.com/wagoodman/dive)

`ranger` est un très bon outil/projet mais assez lent au launch (programme Python)
Une alternative (plus light) `lf` semble être intéressante (et très rapide/efficace, écrit en Go)
[Terminal file manager](https://github.com/gokcehan/lf/releases)

`Mate Panels` -> activer la transparence (avec une couleur neutre, blanc ou noir) et activer l'autohide => meilleur intégration colorimétrique avec le background et plus de hauteur pour les applications
TODO: voir comment on rend le setting programmatique et restaurable
```shell
→ dconf dump /org/mate/panel/toplevels/
[bottom]
auto-hide=true
enable-buttons=false
expand=true
orientation='bottom'
screen=0
size=24
y=744
y-bottom=0

[bottom/background]
color='rgba(0,0,0,0.0309911)'
type='color'

[top]
auto-hide=true
expand=true
orientation='top'
screen=0
size=24

[top/background]
color='rgba(0,0,0,0.037995)'
type='color'
```

Thèmes&Fonts&Icons
Faudrait faire un travail spécifique sur les thèmes et icones,
ça pourrait être intéressant. Par exemple une plateforme d'expérimentation/utilisation pour voir l'effet du thème rapidement dans une VM (par exemple)
- [Candy icons](https://www.gnome-look.org/p/1305251) => cute ^^
- [We10X icon theme](https://www.gnome-look.org/p/1366371)

Version de VirtualBox (qui fonctionne): Version 6.1.42 r155177 (Qt5.15.2) (https://www.virtualbox.org/wiki/Linux_Downloads APT)
Version de Vagrant (qui fonctionne): Vagrant 2.3.4 (installé depuis les packages debian APT)

TODO: tenter de réaliser une CI sur Github Action
https://github.com/jonashackt/vagrant-github-actions
A priori, il y a un trick 
