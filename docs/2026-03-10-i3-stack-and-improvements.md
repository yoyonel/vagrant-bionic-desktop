# 2026-03-10 — i3 Stack & Améliorations

## Contexte

Migration depuis MATE vers un environnement tiling WM orienté dev/test, optimisé pour VirtualBox.
Hyprland (Wayland) écarté — incompatible avec le backend graphique VirtualBox (pas de DRM/KMS).

---

## Nouveautés

### 1. Stack graphique — i3 + Polybar + Kitty + Rofi

Remplace MATE comme environnement par défaut en mode `minimal`.

| Composant | Rôle |
|---|---|
| **i3** | Tiling window manager (X11) |
| **Polybar** | Barre de statut (workspaces, CPU, RAM, volume, horloge) |
| **Kitty** | Terminal GPU-accelerated |
| **Rofi** | Lanceur d'applications et switcher de fenêtres |
| **feh** | Fond d'écran |
| **picom** | Compositeur (transparence, ombres) |
| **dunst** | Notifications desktop |
| **flameshot** | Captures d'écran |
| **nm-applet** | Gestionnaire réseau systray |
| **LightDM** | Display manager (session i3 par défaut) |

Thème : **Nordic** (couleurs `#2E3440` / `#88C0D0`), icônes **Zafiro**, police **SauceCodePro Nerd Font**.

Fichiers de config :
- `dotfile/i3/config`
- `dotfile/polybar/config.ini` + `dotfile/polybar/launch.sh`
- `dotfile/kitty/kitty.conf`
- `dotfile/rofi/config.rasi`

---

### 2. Modes d'installation — `INSTALL_MODE`

Deux modes pilotés par variable d'environnement :

```bash
vagrant up                       # minimal (défaut)
INSTALL_MODE=full vagrant up     # installation complète
```

| Mode | Script | Contenu |
|---|---|---|
| `minimal` | `full-install-minimal.sh` | CLI + git + i3-stack + fonts + keyboard |
| `full` | `full-install.sh` | Tout : MATE, Docker, IDE, flatpak, audio/vidéo... |

---

### 3. Nala — téléchargements apt parallèles

Nala remplace `apt-get install` de façon transparente via un wrapper dans `/usr/local/sbin/apt-get`.
Aucun script modifié : les ~80 occurrences `sudo apt-get install` appellent automatiquement nala.

```
sudo apt-get install foo   →   /usr/local/sbin/apt-get   →   nala install foo
sudo apt-get update        →   apt-get réel (inchangé)
```

Gain estimé : **-30 à -50%** sur la phase de téléchargement des paquets.

Configuré dans : `scripts/.pre-init.sh`

---

### 4. Box Debian mise à jour

```
12.20240212.1  →  12.20250126.1
```

URL : https://portal.cloud.hashicorp.com/vagrant/discover/debian/bookworm64

---

### 5. Justfile — remplace le Makefile

```bash
just                        # liste les recettes disponibles
just vagrant-rebuild        # rebuild complet
just vagrant-build_or_update
just vagrant-ssh
just vagrant-tests
just docker-build
just docker-rebuild
just docker-tests
just docker-shell
just clean                  # vagrant destroy
just reset                  # reset forcé (voir §7)
```

---

### 6. Corrections de bugs

| Problème | Cause | Fix |
|---|---|---|
| `tldr` crash au démarrage | `tldr-hs` (Haskell) corrompu | Remplacé par `tealdeer` (binaire Rust) |
| Erreur TLS sur `deb.debian.org` | Horloge VM décalée au boot | `hwclock --hctosys` dans `.pre-init.sh` |
| `dpkg-preconfigure: unable to re-open stdin` | stdin fermé en session Vagrant | `DPkg::Pre-Install-Pkgs {};` dans apt.conf.d |
| `Package xrandr has no installation candidate` | `xrandr` retiré de Debian 12 | Remplacé par `x11-xserver-utils` |
| `pipx: command not found` dans install-git.sh | install-python.sh absent en mode minimal | Bootstrap pipx en tête de install-git.sh |
| `apt install` au lieu de `apt-get install` | Typo dans install-cli.sh | Corrigé → le wrapper nala s'applique |
| GA version mismatch (6.0.0 vs VBox 7.2) | `vagrant-vbguest auto_update=true` tourne avant apt-get update | Repassé à `auto_update=false` |
| `linux-headers-6.1.0-29-amd64` introuvable | Même problème, `vbguest` compile avant apt update | `linux-headers` retiré de install-common.sh |
| VM orpheline après reset | `.vagrant/` supprimé mais VM reste dans VBox | `VBoxManage unregistervm --delete` dans `just reset` |

---

### 7. Recette `just reset` — reset forcé VirtualBox

En cas de VM bloquée / processus zombie :

```bash
just reset
```

Actions effectuées :
1. `pkill -9` sur VBoxSVC, VBoxXPCOMIPCD, VirtualBox, vagrant
2. Suppression des locks `/tmp/.vbox-*-ipc`
3. Suppression de `.vagrant/`
4. `VBoxManage unregistervm "vagrant-bionic-desktop" --delete`
5. Redémarrage du service `vboxdrv`
6. `VBoxManage list vms` pour vérification

---

## Raccourcis i3

> `Mod` = touche **Super** (Windows ⊞ / Cmd ⌘)

### Applications

| Raccourci | Action |
|---|---|
| `Mod + Return` | Ouvrir Kitty (terminal) |
| `Mod + d` | Rofi — lanceur d'applications |
| `Mod + Tab` | Rofi — switcher de fenêtres |
| `Print` | Flameshot — capture d'écran |

### Fenêtres

| Raccourci | Action |
|---|---|
| `Mod + Shift + q` | Fermer la fenêtre active |
| `Mod + f` | Fullscreen toggle |
| `Mod + Shift + Space` | Basculer flottant / tiling |
| `Mod + Space` | Focus flottant ↔ tiling |

### Focus — navigation

| Raccourci | Action |
|---|---|
| `Mod + ←/↓/↑/→` | Focus fenêtre (flèches) |
| `Mod + h/j/k/l` | Focus fenêtre (vim) |

### Déplacement

| Raccourci | Action |
|---|---|
| `Mod + Shift + ←/↓/↑/→` | Déplacer fenêtre (flèches) |
| `Mod + Shift + h/j/k/l` | Déplacer fenêtre (vim) |

### Layout

| Raccourci | Action |
|---|---|
| `Mod + b` | Split horizontal |
| `Mod + v` | Split vertical |
| `Mod + e` | Toggle split |
| `Mod + s` | Layout stacking |
| `Mod + w` | Layout tabbed |

### Workspaces

| Raccourci | Action |
|---|---|
| `Mod + 1..9` | Aller au workspace N |
| `Mod + Shift + 1..9` | Déplacer fenêtre vers workspace N |

### Redimensionnement

| Raccourci | Action |
|---|---|
| `Mod + r` | Entrer en mode resize |
| `h/l` (resize) | Réduire / agrandir largeur |
| `j/k` (resize) | Agrandir / réduire hauteur |
| `Escape / Enter` | Quitter mode resize |

### Système

| Raccourci | Action |
|---|---|
| `Mod + Ctrl + L` | Verrouiller l'écran (i3lock) |
| `Mod + Shift + c` | Recharger la config i3 |
| `Mod + Shift + r` | Redémarrer i3 |
| `Mod + Shift + e` | Quitter i3 (avec confirmation) |

### Audio

| Raccourci | Action |
|---|---|
| `XF86AudioRaiseVolume` | Volume +5% |
| `XF86AudioLowerVolume` | Volume -5% |
| `XF86AudioMute` | Mute toggle |

---

## Structure des fichiers modifiés

```
vagrant-bionic-desktop/
├── Vagrantfile                        # INSTALL_MODE, box 12.20250126.1, vbguest config
├── justfile                           # remplace Makefile, + recettes reset/rebuild
├── full-install-minimal.sh            # NOUVEAU — installation minimale opérationnelle
├── rebuild.sh                         # plugins installés une seule fois
├── scripts/
│   ├── .pre-init.sh                   # nala wrapper, hwclock, dpkg-preconfigure fix
│   ├── install-i3-stack.sh            # NOUVEAU — i3 + Polybar + Kitty + Rofi + LightDM
│   ├── install-common.sh              # retiré linux-headers
│   ├── install-cli.sh                 # tealdeer, apt-get fix, tldr --update
│   └── install-git.sh                 # bootstrap pipx si absent
└── dotfile/
    ├── i3/config                      # NOUVEAU
    ├── polybar/config.ini             # NOUVEAU
    ├── polybar/launch.sh              # NOUVEAU
    ├── kitty/kitty.conf               # NOUVEAU
    └── rofi/config.rasi               # NOUVEAU
```
