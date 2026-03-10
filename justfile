set dotenv-load
set shell := ["bash", "-c"]

dir := `realpath .`

# List available recipes
default:
    @just --list

# Build vagrant box and docker image
all: vagrant-build_or_update docker-build

# Launch a SSH connection on vagrant box
vagrant-ssh:
    vagrant ssh --color --no-tty -c zsh -- -X

# Launch versions checking on vagrant box
vagrant-tests:
    ./vagrant_tests.sh

# ReBuild from scratch vagrant box
vagrant-rebuild:
    ./rebuild.sh

# Build Or Update vagrant box
vagrant-build_or_update:
    ./build_or_update.sh

# Build docker image
docker-build:
    docker build -t vagrant-bionic-desktop:debian-latest --progress=plain . 2>&1 | tee docker-build.log

# Build docker image without caches
docker-rebuild:
    docker build --no-cache -t vagrant-bionic-desktop:debian-latest --progress=plain . 2>&1 | tee docker-build.log

# Launch versions checking on docker container
docker-tests:
    docker run -it --rm vagrant-bionic-desktop:debian-latest zsh -c "source ~/.zshrc 2>/dev/null; ./check-versions.sh 2>/dev/null"

# Run a shell command interpreter on docker container
docker-shell:
    docker run -it --rm vagrant-bionic-desktop:debian-latest zsh

# Remove vagrant artifacts
clean:
    vagrant destroy --force

# Hard reset: kill all VirtualBox/Vagrant processes, clean state, restart vboxdrv
reset:
    -sudo pkill -9 -f VBoxSVC
    -sudo pkill -9 -f VBoxXPCOMIPCD
    -sudo pkill -9 -f VirtualBox
    -sudo pkill -9 -f vagrant
    -sudo rm -f /tmp/.vbox-*-ipc
    -sudo rm -f /root/.config/VirtualBox/*.lock
    -rm -rf .vagrant/
    -VBoxManage unregistervm "vagrant-bionic-desktop" --delete
    sudo systemctl restart vboxdrv 2>/dev/null || sudo /sbin/rcvboxdrv restart || true
    VBoxManage list vms
