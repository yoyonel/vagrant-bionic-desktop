# VirtualBox Guest Additions — Fix & Guide de test

> Date : 2026-04-02  
> Commits : `d8bd516`, `aac47eb` (branche `develop`)  
> Contexte : voir aussi `2026-04-02-architecture-analysis.md`

---

## Problèmes résolus

| # | Symptôme | Cause |
|---|---|---|
| 1 | Rendu garbled (texte/fonts corrompus) | `accelerate3d=on` incompatible VBoxSVGA + GA 6.0.0 |
| 2 | Fullscreen/resize non fonctionnel | GA 6.0.0 dans la box Debian, host VBox 7.2 |
| 3 | Échec provision : `E: Unable to locate linux-headers-6.1.0-29-amd64` | `vagrant-vbguest auto_update=true` compilait GA **avant** `apt-get update` |
| 4 | Version GA toujours figée à 7.0.6 | ISO Debian (`virtualbox-guest-additions-iso`) jamais mise à jour |

---

## Architecture du fix

```
Host (machine physique)
│
├── VBoxManage --version  →  "7.2.6r172322"
│                                │
│                         Vagrantfile
│                         VBOX_VERSION = "7.2.6"   ← strippé du suffix rXXX
│                                │
│                         injecté comme env var dans le provisioner
│                                │
└── VM (Vagrant / VirtualBox)
         │
         scripts/install-i3-stack.sh
         │   VBOX_VERSION="7.2.6"   ← reçu depuis Vagrantfile
         │
         ├── télécharge depuis Oracle CDN :
         │   https://download.virtualbox.org/virtualbox/7.2.6/VBoxGuestAdditions_7.2.6.iso
         │
         ├── valide l'ISO : file *.iso | grep 'ISO 9660'
         ├── monte + VBoxLinuxAdditions.run --nox11
         ├── systemctl enable vboxadd vboxadd-service
         └── vérifie : VBoxService --version == "7.2.6"
```

Au démarrage de session i3 (`i3/config`) :
```
exec --no-startup-id VBoxClient-all
```
`VBoxClient-all` active le resize dynamique, le clipboard partagé et le seamless mode.

---

## Commandes de test

> **Légende** :  
> `[HOST]` = à exécuter sur ta machine physique (dans le dossier du repo)  
> `[VM]` = à exécuter dans la VM (via `vagrant ssh` ou directement dans le terminal VM)

---

### Test 1 — Vérification rapide sur VM running

Lance la suite de checks GA uniquement, sans relancer tout `check-versions.sh` :

```bash
# [HOST]
vagrant ssh --no-tty --command \
  "VBOX_HOST_VERSION=$(VBoxManage --version | sed 's/r.*//') \
   DISPLAY=:0 \
   zsh -c 'source ~/.zshrc 2>/dev/null; scripts/check-versions.sh 2>/dev/null'" \
  | grep -A20 "VirtualBox Guest"
```

**Résultat attendu (6 ✅) :**
```
── VirtualBox Guest Additions ──────────────────────────────────────────
✅ /usr/sbin/VBoxService --version: 7.2.6r172322
✅ GA version matches host VBox: 7.2.6
✅ systemctl is-active vboxadd: active
✅ lsmod | grep -q vboxguest && echo 'vboxguest module loaded': vboxguest module loaded
✅ pgrep -a VBoxClient | head -3: [liste des processus VBoxClient]
✅ DISPLAY=:0 xrandr | grep -q 'Virtual1 connected' && ...: xrandr: Virtual1 connected (resize capable)
```

---

### Test 2 — Suite de tests complète

Lance tous les checks (versions des outils + GA) :

```bash
# [HOST]
./vagrant_tests.sh
```

`VBOX_HOST_VERSION` est automatiquement détecté depuis le host et injecté dans la VM.

---

### Test 3 — Vérifier les versions manuellement dans la VM

```bash
# [HOST → ouvre une session SSH interactive]
vagrant ssh

# [VM] — vérifier la version GA installée
/usr/sbin/VBoxService --version
# attendu : 7.2.6r172322

# [VM] — vérifier que les services sont actifs
systemctl is-active vboxadd vboxadd-service
# attendu : active / active

# [VM] — vérifier que le module kernel est chargé
lsmod | grep vboxguest
# attendu : une ligne vboxguest (taille + modules dépendants)

# [VM] — vérifier les processus VBoxClient (resize/clipboard)
pgrep -a VBoxClient
# attendu : plusieurs lignes (VBoxClient --draganddrop, --clipboard, --vmsvga...)

# [VM] — vérifier les modes écran disponibles (resize xrandr)
DISPLAY=:0 xrandr | head -5
# attendu : "Virtual1 connected primary NxN+0+0"
```

---

### Test 4 — Rebuild complet depuis zéro (non-régression provisioner)

C'est le test le plus important — il couvre tout le chemin de provision :

```bash
# [HOST] — détruire et reconstruire la VM
vagrant destroy -f && vagrant up
```

Le provisioner va :
1. Activer `contrib non-free` dans `sources.list`
2. Télécharger l'ISO GA depuis Oracle CDN (version = version VBox du host)
3. Valider l'ISO, monter, compiler, activer les services

Après le boot :

```bash
# [HOST]
./vagrant_tests.sh
```

**Ce qui peut échouer et comment le diagnostiquer :**

| Erreur | Cause probable | Action |
|---|---|---|
| `ERROR: downloaded file is not a valid ISO` | CDN Oracle indisponible ou URL 404 | Vérifier `curl -sI https://download.virtualbox.org/virtualbox/7.2.6/VBoxGuestAdditions_7.2.6.iso` depuis le host |
| `E: Unable to locate linux-headers-X.Y.Z` | `contrib non-free` pas activé dans sources.list | Vérifier `cat /etc/apt/sources.list` dans la VM |
| `WARNING: VBoxService not found after install` | Échec de compilation du module kernel | `vagrant ssh` → `sudo /sbin/rcvboxadd quicksetup all` |
| `vboxguest` absent de `lsmod` | Module non chargé après install | `vagrant ssh` → `sudo modprobe vboxguest` |

---

### Test 5 — Simulation upgrade VirtualBox host (test de l'idempotence)

Quand tu upgrades VirtualBox sur le host (ex. 7.2.6 → 7.3.x), le provisioner doit détecter le mismatch et réinstaller automatiquement.

**Vérifier que l'URL future est valide avant d'upgrader :**

```bash
# [HOST] — remplacer 7.3.0 par la version cible
NEW_VERSION="7.3.0"
curl -sI "https://download.virtualbox.org/virtualbox/${NEW_VERSION}/VBoxGuestAdditions_${NEW_VERSION}.iso" \
  | grep "^HTTP"
# attendu : HTTP/1.1 200 OK
```

**Après upgrade VirtualBox sur le host, pour mettre à jour les GA dans la VM existante :**

```bash
# [HOST] — relance uniquement les provisioners (pas de destroy)
vagrant provision
```

Le script compare `VBoxService --version` (ancienne version) vs `$VBOX_VERSION` (nouvelle version détectée) → déclenche le téléchargement + réinstallation.

**Vérifier le résultat :**

```bash
# [HOST]
./vagrant_tests.sh
# Le check "GA version matches host VBox" doit être ✅ avec la nouvelle version
```

---

## Gaps connus

| Scénario | Statut |
|---|---|
| VM running, checks GA | ✅ couvert — `vagrant_tests.sh` |
| Rebuild from scratch | ✅ couvert — `vagrant destroy -f && vagrant up` |
| Host VBox upgrade + re-provision | ✅ couvert — `vagrant provision` |
| CDN Oracle down | ⚠️ pas de fallback — provision échoue proprement avec message d'erreur explicite |
| CI automatisée sur rebuild | ❌ les GitHub Actions workflows sont EOL (voir section 5 de `2026-04-02-architecture-analysis.md`) |
