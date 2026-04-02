# ---------------------------------------------------------------------------
# INSTALL_MODE: controls which provisioning script is used
#   minimal (default) — CLI + i3-stack + fonts + keyboard  (~15–20 min)
#   full              — everything: MATE, Docker, IDE, flatpak, etc.
#
# Usage:
#   vagrant up                       # minimal (default)
#   INSTALL_MODE=full vagrant up     # full install
# ---------------------------------------------------------------------------
INSTALL_MODE = ENV.fetch("INSTALL_MODE", "minimal")
INSTALL_SCRIPT = INSTALL_MODE == "full" ? "full-install.sh" : "full-install-minimal.sh"

Vagrant.configure("2") do |config|
  # https://app.vagrantup.com/debian/boxes/bullseye64/versions/11.20221219.1
  config.vm.box = "debian/bookworm64"
  config.vm.box_version = "12.20250126.1"
  # config.vm.box_version = "12.20240212.1"
  # config.vm.box_version = "12.20231211.1"
  # config.vm.box_version = "11.20221219.1"

  # vagrant-vbguest: keep auto_update disabled — the GA version mismatch
  # (6.0.0 vs 7.2) is non-critical for our use case (no shared folders).
  # Auto-compilation is disabled because it runs before apt-get update,
  # causing linux-headers lookup failures on a fresh box.
  # Configuration pour vagrant-vbguest
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true # Utilise l'ISO locale de VirtualBox
  end

  # Optional - enlarge disk (will also convert the format from VMDK to VDI):l
  # config.disksize.size = "50GB"

  # # https://github.com/dotless-de/vagrant-vbguest/issues/335
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #   config.vbguest.auto_update = false
  # end
  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  # config.vbguest.auto_update = true

  # https://github.com/tmatilai/vagrant-timezone
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  config.vm.provider "virtualbox" do |vb|
    # Virtual Machine Name
    vb.name = "vagrant-bionic-desktop"
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    vb.memory = INSTALL_MODE == "full" ? 4096 : 4096
    vb.cpus   = INSTALL_MODE == "full" ? 4    : 4
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional', '--graphicscontroller', 'vmsvga']
    # Set the video memory to 128Mb
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    # Allow the VM window to be freely resized (triggers guest resolution update)
    vb.customize ["setextradata", :id, "GUI/LastScaleFactors", ""]

    vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "emptydrive"]
  end

  # UI Ressources: Themes, Wallpapers
  config.vm.provision "file", source: "data/Mate_M013_4K.png", destination: ".local/share/wallpapers/Mate_M013_4K.png"
  config.vm.provision "file", source: "data/Nordic-darker.tar.xz", destination: "/tmp/Nordic-darker.tar.xz"
  config.vm.provision "file", source: "data/Zafiro-Icons.tar.xz", destination: "/tmp/Zafiro-Icons.tar.xz"
  #
  config.vm.provision "file", source: "scripts/", destination: "/home/vagrant/scripts"
  config.vm.provision "file", source: "scripts/.post-init.sh", destination: "/home/vagrant/.post-init.sh"
  config.vm.provision "file", source: "scripts/.post-init-mate-theme.sh", destination: "/home/vagrant/.post-init-mate-theme.sh"
  config.vm.provision "file", source: "scripts/.post-init-flatpak.sh", destination: "/home/vagrant/.post-init-flatpak.sh"
  #
  config.vm.provision "shell", privileged: false, path: INSTALL_SCRIPT
  #
  config.vm.provision "file", source: "dotfile/.profile", destination: "/home/vagrant/.profile"
  config.vm.provision "file", source: "dotfile/.gitconfig", destination: "/home/vagrant/.gitconfig"
  config.vm.provision "file", source: "dotfile/.zshrc", destination: "/home/vagrant/.zshrc"
  config.vm.provision "file", source: "dotfile/.tmux.conf.local", destination: "/home/vagrant/.tmux.conf.local"
  # config.vm.provision "file", source: "dotfile/.powerlevel9k", destination: "/home/vagrant/.powerlevel9k"
  config.vm.provision "file", source: "dotfile/.p10k.zsh", destination: "/home/vagrant/.p10k.zsh"
  config.vm.provision "file", source: "dotfile/alacritty.yml", destination: "/home/vagrant/.config/alacritty/alacritty.yml"
  config.vm.provision "file", source: "dotfile/dconf.ini", destination: "/home/vagrant/.config/dconf/dconf.ini"
  config.vm.provision "file", source: "dotfile/rc.conf", destination: "/home/vagrant/.config/ranger/rc.conf"
  # i3 stack — tiling WM
  config.vm.provision "file", source: "dotfile/i3/config", destination: "/home/vagrant/.config/i3/config"
  config.vm.provision "file", source: "dotfile/polybar/config.ini", destination: "/home/vagrant/.config/polybar/config.ini"
  config.vm.provision "file", source: "dotfile/polybar/launch.sh", destination: "/home/vagrant/.config/polybar/launch.sh"
  config.vm.provision "file", source: "dotfile/kitty/kitty.conf", destination: "/home/vagrant/.config/kitty/kitty.conf"
  config.vm.provision "file", source: "dotfile/rofi/config.rasi", destination: "/home/vagrant/.config/rofi/config.rasi"
  #
  config.vm.provision 'shell', inline: 'echo "vagrant:vagrant" | chpasswd'
end
