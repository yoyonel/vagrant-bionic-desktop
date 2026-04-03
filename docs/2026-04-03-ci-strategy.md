# CI/CD Strategy — VirtualBox/Vagrant box production

> Date : 2026-04-03  
> Contexte : voir aussi `2026-04-02-architecture-analysis.md` §5

---

## Problème

GitHub Actions ne peut pas exécuter VirtualBox sur la majorité de ses runners, ce qui
empêche de valider les recettes de provisioning en CI.

### Pourquoi VirtualBox est difficile en CI

VirtualBox nécessite deux choses côté hôte :
1. **CPU x86 avec VT-x** (virtualisation hardware Intel)
2. **Kernel modules** (`vboxdrv`, `vboxnetflt`) chargés sur l'OS hôte

| Runner GHA | Architecture | VT-x | VirtualBox | Remarque |
|---|---|---|---|---|
| `ubuntu-latest` | x86 | ✅ KVM dispo | ⚠️ Possible mais instable | Nested virt, pas de garantie driver |
| `macos-13` | Intel x86 | ✅ | ✅ | **Dernier runner Intel sur GHA** |
| `macos-14` | Apple Silicon ARM | ❌ | ❌ | VBox ne tourne pas sur ARM |
| `macos-15` | Apple Silicon ARM | ❌ | ❌ | Idem |
| `macos-latest` | Apple Silicon ARM | ❌ | ❌ | Actuellement macos-15 |
| `windows-latest` | x86 | ✅ | ⚠️ Possible | Peu testé, overhead élevé |

**`macos-latest` pointe aujourd'hui sur Apple Silicon (macos-15)** — c'est pourquoi
`brew install --cask virtualbox` échoue silencieusement ou produit une version ARM
non fonctionnelle.

---

## Solution retenue — `macos-13` (court terme)

```yaml
runs-on: macos-13
```

```yaml
- name: Install VirtualBox
  run: brew install --cask virtualbox

- name: Install latest Vagrant version
  run: brew install hashicorp/tap/hashicorp-vagrant
```

### Pourquoi `macos-13`

- Dernier runner Intel (x86) disponible sur GitHub Actions
- VirtualBox s'installe via Homebrew sans manipulation kernel manuelle
- Cohérent avec l'approche existante du projet (provider VirtualBox natif)
- Changement minimal : deux lignes dans chaque workflow

### Durée de vie estimée

GitHub n'a pas annoncé de date de retrait pour `macos-13`, mais la trajectoire est
claire : chaque nouvelle génération de runner macOS est ARM. Il faut anticiper une
migration vers l'option libvirt (voir ci-dessous) à moyen terme.

---

## Option alternative — Linux + libvirt/KVM (moyen terme)

Ubuntu runners supportent nativement KVM. `vagrant-libvirt` permet d'utiliser
Vagrant avec QEMU/KVM comme provider à la place de VirtualBox.

```yaml
runs-on: ubuntu-latest

steps:
  - name: Enable KVM
    run: |
      sudo apt-get install -y qemu-kvm libvirt-daemon-system vagrant
      sudo adduser $USER libvirt
      vagrant plugin install vagrant-libvirt
```

Le Vagrantfile garderait VirtualBox comme provider par défaut (usage local) et
libvirt comme provider CI explicite :

```ruby
# Vagrantfile — provider libvirt (CI headless)
config.vm.provider "libvirt" do |lv|
  lv.memory = 4096
  lv.cpus   = 4
  lv.graphics_type = "none"
end
```

Déclenchement CI :
```bash
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up
```

### Trade-offs libvirt

| Avantage | Inconvénient |
|---|---|
| Stable, natif Linux, pas de dépendance ARM | Refactor Vagrantfile (ajout provider block) |
| Rapide (KVM natif, pas d'émulation) | `vagrant package` produit une box libvirt ≠ VirtualBox |
| `ubuntu-latest` = durable, pas d'EOL imminent | Tests display/resize non applicables (headless) |
| Gratuit en minutes GHA (Linux < macOS) | vagrant-libvirt plugin à maintenir |

### Ce qui serait testable en CI avec libvirt

✅ Tous les scripts de provisioning (apt, pip, git, cli tools...)  
✅ `vagrant_tests.sh` via SSH (versions, services, GA*)  
✅ Idempotence des scripts (`vagrant provision` 2x)  
❌ Rendu i3 / polybar / kitty (pas de display)  
❌ VirtualBox Guest Additions (spécifique VBox)  
❌ Resize / fullscreen VirtualBox  

*Les checks GA seraient désactivés en mode libvirt (pas de VBoxService).

---

## Option alternative — Packer + QEMU (long terme)

Sépare "construction d'image" de "test de provisioning" :

```
Packer (QEMU, Linux CI)          Vagrant (local dev)
  → build depuis scripts            → consomme la box Packer
  → output .box Vagrant             → VirtualBox provider
  → upload artifact GHA             → GUI, resize, clipboard
```

Le fichier `packer.pkr.hcl` serait la source de vérité pour la construction.
Vagrant ne serait plus utilisé en CI, seulement en local.

**Effort** : significatif (nouveau fichier Packer, migration CI complète).  
**Pertinence** : si le projet évolue vers une distribution publique de la box.

---

## État actuel des workflows

| Fichier | Runner | VBox installé | Déclenchement |
|---|---|---|---|
| `build-vagrant-box.yml` | `macos-13` | ✅ `brew install --cask virtualbox` | push `master` + `workflow_dispatch` + cron daily |
| `build-vagrant-box-dev.yml` | `macos-13` | ✅ `brew install --cask virtualbox` | push `develop` + `workflow_dispatch` + cron daily |

---

## Retour d'expérience — disponibilité des runners `macos-13` (2026-04-03)

### Observation

Après le premier push sur `develop` avec `macos-13`, les deux runs ont été
`cancelled` **instantanément sans aucun step exécuté** :

```
23942204029  build-vagrant-box [dev]  completed  cancelled  labels: ['macos-13']
23942051486  build-vagrant-box [dev]  completed  cancelled  labels: ['macos-13']
```

Le job demandait le runner `macos-13` mais aucun runner n'était disponible — GHA
annule le job au lieu de le mettre en queue sur le plan free.

### Cause

Sur le **plan free GitHub Actions**, les runners `macos-13` (Intel) ont une
disponibilité réduite comparée aux runners `ubuntu-latest`. Les jobs peuvent être
annulés si :
- La queue est saturée
- L'allocation de runners Intel est épuisée dans la région

### Solution de contournement ajoutée — `workflow_dispatch`

Les deux workflows ont été enrichis avec le trigger `workflow_dispatch` :

```yaml
on:
  push:
    branches: [master]  # ou develop
  workflow_dispatch:    # ← déclenchement manuel depuis l'UI GitHub
  schedule:
    - cron: "0 0 * * *"
```

**Pour relancer manuellement sans commit vide :**
```
GitHub → repo → Actions → "build-vagrant-box [dev]" → Run workflow → Branch: develop
```

Ou via CLI :
```bash
# [HOST]
gh workflow run build-vagrant-box-dev.yml --ref develop
```

### Stratégie de retry

Si le runner `macos-13` n'est pas disponible immédiatement :
1. Attendre quelques heures et relancer via `workflow_dispatch`
2. Le cron daily (`0 0 * * *`) retentera automatiquement chaque nuit

---

## Risques connus et surveillance

| Risque | Probabilité | Impact | Mitigation |
|---|---|---|---|
| GitHub retire `macos-13` | Moyen terme | CI cassée | Migrer vers libvirt (option 2) |
| `brew install --cask virtualbox` échoue | Faible | CI cassée | Fallback : télécharger le `.dmg` Oracle directement |
| VirtualBox system extension bloquée par macOS CI | Moyen | `vagrant up` échoue | Documenter le workaround ou migrer libvirt |
| `macos-13` plus cher en minutes GHA | Actuel | Coût | Acceptable pour un projet perso |

### Comment détecter si `macos-13` a été retiré

```bash
# [HOST] — vérifier les runners disponibles via GHA API
curl -s https://api.github.com/repos/<owner>/<repo>/actions/runners \
  | jq '.runners[].labels[].name' | grep macos
```

Ou simplement : si le workflow échoue avec `No runner matching the specified labels`,
c'est que `macos-13` a été retiré → migrer vers libvirt.
