# Architecture Analysis — `vagrant-bionic-desktop`

> Date : 2026-04-02  
> Scope : analyse complète du repo (code, scripts, CI, dotfiles, binaires)

---

## 1. Vue d'ensemble

Provisioner de desktop de développement personnel, dual-target **Vagrant/VirtualBox + Docker**, qui a évolué Ubuntu 18.04 → Debian 11 → Debian 12. La refonte de mars 2026 (voir `2026-03-10-i3-stack-and-improvements.md`) a migré MATE → i3+Polybar+Kitty+Rofi avec un split `minimal`/`full`.

### Structure macro

```
Vagrantfile / Dockerfile
       │
       ├── full-install.sh          (22 scripts sourcés)
       └── full-install-minimal.sh  (12 scripts sourcés)
              │
              └── scripts/
                    ├── .pre-init.sh / .post-init.sh   (lifecycle hooks)
                    ├── .tools.sh                       (helpers partagés)
                    └── install-*.sh                    (30+ modules)
```

### Points forts du design

- Un script par domaine (`cli`, `git`, `python`, `i3-stack`…) — bonne séparation des responsabilités
- Guards idempotents systématiques (`command_exists`, `package_installed`) dans chaque script
- Thème **Nordic cohérent** sur tout le bureau (i3, polybar, kitty, rofi — mêmes valeurs HEX)
- Le wrapper nala transparent (`/usr/local/sbin/apt-get`) est élégant : aucun script install à modifier
- Banners figlet dans chaque script → logs de provisioning lisibles et structurés

---

## 2. Bugs identifiés

| # | Fichier | Problème |
|---|---|---|
| 1 | `install_from_server.sh` | Invoque `sh "scripts/full-install.sh"` — ce fichier n'existe pas (il est à la racine) |
| 2 | `scripts/install-ide.sh` | `if false and [...]` — `and` n'est pas du bash valide |
| 3 | `scripts/install-system.sh` | Télécharge vagrant `2.2.16` mais `vagrant_2.4.3-1_amd64.deb` est committé à la racine — incohérence de version |

---

## 3. Dette technique

### Dead code

| Élément | Raison |
|---|---|
| `scripts/figlet.sh` | Jamais appelé depuis aucun provisioner |
| `dotfile/.powerlevel9k` | Commenté dans `.zshrc`, supersédé par `.p10k.zsh` |
| Blocs `if false` dans plusieurs scripts | PyCharm, Slack, VSCode désactivés mais laissés en place |
| `scripts/install-communication_news.sh` | Discord/Slack/Brave entièrement commentés, le script ne fait quasiment rien |

### Double installation

`flameshot` est installé dans `scripts/install-graphics_photography.sh` **ET** dans `scripts/install-i3-stack.sh`. Le premier script ne fait que ça — il est redondant en mode `full`.

### Ternaire mort dans le Vagrantfile

```ruby
# Les deux branches sont identiques — aucune différenciation réelle entre modes
vb.memory = INSTALL_MODE == "full" ? 4096 : 4096
vb.cpus   = INSTALL_MODE == "full" ? 4    : 4
```

### Nommage obsolète

- Repo nommé `vagrant-bionic-desktop` alors qu'il tourne sur **Debian 12 Bookworm**. "Bionic" est Ubuntu 18.04.
- `vb.name = "vagrant-bionic-desktop"` dans le Vagrantfile.

---

## 4. Documentation stale

| Fichier | Décalage |
|---|---|
| `README.md` | Dit "Ubuntu 18.04 LTS" et clavier allemand (`L='de'`) — réalité : Debian 12 + FR |
| `dotfile/alacritty.yml` | 823 lignes dont ~95% de boilerplate commenté ; **section `[colors]` entièrement commentée** → defaulte sur "Tomorrow Night", incohérent avec Nordic |
| `dotfile/.tmux.conf.local` | Couleurs gpakosz amber/yellow par défaut — pas Nordic, incohérent avec le reste |

---

## 5. CI/CD — Problèmes

| # | Fichier | Problème |
|---|---|---|
| 1 | `build-vagrant-box dev.yml` | **Espace dans le nom de fichier** — non-standard, problèmes avec certains outils CLI |
| 2 | même fichier | `runs-on: macos-10.15` — EOL sur GitHub Actions |
| 3 | les deux workflows | `actions/checkout@v2`, `upload-artifact@v3`, `cache@v2` — dépréciés, utiliser v4 |
| 4 | les deux workflows | `on: push` sans filtre de branche — les deux CI tournent sur chaque push, y compris les branches feature |

---

## 6. Binaires dans git

```
vagrant_2.4.3-1_amd64.deb                            (~150 MB)
Oracle_VirtualBox_Extension_Pack-7.2.6.vbox-extpack  (~100 MB)
```

Ces binaires gonflent l'historique git de façon **permanente et irréversible**. Ils devraient être téléchargés à provision-time depuis leurs sources officielles.

---

## 7. Curiosité non documentée — `virtbox_postinit.sh`

Le script injecte `"vqgrqnt"` au lieu de `"vagrant"` intentionnellement : le VM a le clavier AZERTY (FR), donc VBoxManage translate physiquement `a→q`. Idem `"qlqcritty"` pour `"alacritty"`. C'est **correct** mais totalement non documenté dans le script.

---

## 8. Propositions d'améliorations

### Priorité haute

**1. Supprimer les binaires de git**

Ajouter au `.gitignore` :
```
*.deb
*.vbox-extpack
```
Dans les provisioners, télécharger à la volée depuis les URLs officielles.

**2. Corriger `install_from_server.sh`**
```bash
# avant
sh "scripts/full-install.sh"
# après
bash full-install.sh
```

**3. Différencier vraiment minimal vs full dans le Vagrantfile**
```ruby
vb.memory = INSTALL_MODE == "full" ? 4096 : 2048
vb.cpus   = INSTALL_MODE == "full" ? 4 : 2
```

**4. Renommer le workflow dev** (supprimer l'espace)
```
build-vagrant-box dev.yml  →  build-vagrant-box-dev.yml
```

### Priorité moyenne

**5. Supprimer ou fusionner les scripts morts**

- `install-graphics_photography.sh` → fusionner dans `install-i3-stack.sh` ou supprimer
- `dotfile/.powerlevel9k` → supprimer
- `scripts/figlet.sh` → supprimer ou intégrer quelque part

**6. Mettre à jour la CI**
```yaml
uses: actions/checkout@v4
uses: actions/upload-artifact@v4
uses: actions/cache@v4
runs-on: macos-latest
on:
  push:
    branches: [master]   # filtrer par branche selon le workflow
```

**7. Activer les couleurs Nordic dans alacritty**

La section `[colors]` est entièrement commentée dans `dotfile/alacritty.yml` — décommenter et aligner les valeurs sur le reste du setup (Nordic palette).

**8. Rendre `check-versions.sh` aware du mode d'installation**
```bash
INSTALL_MODE="${INSTALL_MODE:-minimal}"
if [[ "$INSTALL_MODE" == "full" ]]; then
  # tester docker, vagrant, alacritty, brave...
fi
```

### Priorité basse

**9. Renommer le repo** → `vagrant-bookworm-desktop` ou `vagrant-debian-desktop`

**10. Documenter le mapping AZERTY dans `virtbox_postinit.sh`** — ajouter un commentaire expliquant pourquoi les chaînes injectées sont "déformées"

**11. Nettoyer `dotfile/alacritty.yml`** — garder les ~30 lignes actives, supprimer les 800 lignes de boilerplate commenté

**12. Aligner `dotfile/.tmux.conf.local`** sur la palette Nordic pour la cohérence visuelle complète

**13. Mettre à jour le README** — Debian 12, clavier FR, WM i3 (pas MATE)

---

## 9. Résumé

Le repo est **architecturalement solide** (idempotence, modularité, thème cohérent, logging structuré) mais souffre d'**accumulation naturelle de dette** liée à plusieurs migrations d'OS et de WM successives.

Priorités les plus impactantes par ordre décroissant :
1. Binaires dans git (impact sur l'historique permanent)
2. Mise à jour CI (workflows EOL/dépréciés)
3. Bug `install_from_server.sh` (cassé silencieusement)
4. Nettoyage dead code (lisibilité/maintenance)
5. README et documentation à jour
