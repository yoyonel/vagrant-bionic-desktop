# Binaires dans git — Nettoyage & politique

> Date : 2026-04-02  
> Commit : `1e2382b` (branche `develop`)

---

## Problème

Deux fichiers binaires volumineux étaient présents à la racine du repo, **non commités mais non ignorés** par `.gitignore` :

```
vagrant_2.4.3-1_amd64.deb                            146 MB
Oracle_VirtualBox_Extension_Pack-7.2.6.vbox-extpack   19 MB
```

**Risque concret :** un `git add .` accidentel aurait committé ~165 MB dans l'historique git.  
Un binaire committé dans git est **permanent et irréversible** sans réécrire l'historique complet (`git filter-branch` / BFG Repo Cleaner) — opération destructive et bloquante pour tous les collaborateurs.

Par ailleurs, `scripts/install-system.sh` téléchargeait vagrant `2.2.16` (EOL depuis 2022) — version incohérente avec le `2.4.3` présent dans le repo.

---

## Nature des deux fichiers

### `vagrant_2.4.3-1_amd64.deb` — paquet Debian de Vagrant (guest tool)

- **Usage** : installé **dans la VM** Debian par `scripts/install-system.sh` (mode `full`)
- **Source officielle** : `https://releases.hashicorp.com/vagrant/<VERSION>/vagrant_<VERSION>-1_amd64.deb`
- **Fix** : téléchargé à provision-time dans `install-system.sh`, supprimé après install
- **Mise à jour** : modifier la variable `VAGRANT_VERSION` dans `scripts/install-system.sh`

### `Oracle_VirtualBox_Extension_Pack-7.2.6.vbox-extpack` — Extension Pack VirtualBox (host tool)

- **Usage** : installé sur le **HOST uniquement** (pas dans la VM) — active USB 2/3, webcam host, Remote Display (RDP)
- **Non utilisé par aucun script de provisioning**
- **Fix** : simplement ignoré via `.gitignore` + install manuelle documentée ci-dessous

---

## Ce qui a été fait

### `.gitignore` — ajout des patterns

```gitignore
# Large binaries — never commit these, download at provision/install time
# vagrant .deb: downloaded by scripts/install-system.sh from releases.hashicorp.com
# vbox-extpack: installed manually on the HOST via VBoxManage
*.deb
*.vbox-extpack
```

### `scripts/install-system.sh` — vagrant 2.2.16 → 2.4.3

```bash
# avant
[ ! -f /tmp/vagrant_2.2.16_x86_64.deb ] && wget -q \
    https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.deb \
    -O /tmp/vagrant_2.2.16_x86_64.deb
sudo dpkg -i /tmp/vagrant_2.2.16_x86_64.deb

# après
VAGRANT_VERSION="2.4.3"
VAGRANT_DEB="/tmp/vagrant_${VAGRANT_VERSION}_amd64.deb"
[ ! -f "$VAGRANT_DEB" ] && wget -q \
    "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}-1_amd64.deb" \
    -O "$VAGRANT_DEB"
sudo dpkg -i "$VAGRANT_DEB"
rm -f "$VAGRANT_DEB"   # cleanup après install
```

---

## Politique pour les binaires (à suivre)

**Ne JAMAIS commiter dans ce repo :**
- Fichiers `.deb`, `.rpm`, `.pkg`
- Fichiers `.vbox-extpack`, `.iso`
- Archives compilées (`.AppImage`, binaires sans extension)

**À la place :**
1. Télécharger depuis la source officielle au moment de l'usage (provision-time ou install manuelle)
2. Référencer la version dans une variable dans le script concerné
3. Nettoyer le fichier téléchargé après usage (`rm -f`)

---

## Opérations manuelles

### Mettre à jour la version de vagrant dans la VM

```bash
# [HOST] — modifier la variable dans le script
# scripts/install-system.sh : VAGRANT_VERSION="X.Y.Z"

# [HOST] — vérifier que l'URL existe
NEW_VERSION="X.Y.Z"
curl -sI "https://releases.hashicorp.com/vagrant/${NEW_VERSION}/vagrant_${NEW_VERSION}-1_amd64.deb" \
  | grep "^HTTP"
# attendu : HTTP/2 200

# [HOST] — reprovisionner la VM (ne pas rebuilder depuis zéro)
vagrant provision
```

### Installer l'Extension Pack VirtualBox sur le host

> L'Extension Pack est à installer sur le **host** uniquement (ta machine physique), pas dans la VM.

```bash
# [HOST] — télécharger la version correspondant à ta version VBox
VBOX_VERSION=$(VBoxManage --version | sed 's/r.*//')
wget "https://download.virtualbox.org/virtualbox/${VBOX_VERSION}/Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack"

# [HOST] — installer
VBoxManage extpack install Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack

# [HOST] — nettoyage
rm Oracle_VirtualBox_Extension_Pack-${VBOX_VERSION}.vbox-extpack
```

Ou via l'interface graphique : **VirtualBox → Fichier → Outils → Extension Pack Manager → +**.

### Vérifier qu'aucun binaire n'est suivi par git

```bash
# [HOST] — lister les fichiers non ignorés > 1 MB (détection préventive)
git ls-files -o --exclude-standard | xargs -I{} find {} -size +1M 2>/dev/null

# [HOST] — vérifier que les patterns gitignore fonctionnent
git check-ignore -v *.deb *.vbox-extpack
# attendu :
#   .gitignore:9:*.deb     vagrant_X.Y.Z-1_amd64.deb
#   .gitignore:10:*.vbox-extpack  Oracle_VirtualBox_Extension_Pack-...
```
