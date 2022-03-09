Vagrant.configure("2") do |config|
  # https://app.vagrantup.com/boxomatic/boxes/debian-11
  config.vm.box = "boxomatic/debian-11"
  config.vm.box_version = "20220301.0.1"
  
  # Optional - enlarge disk (will also convert the format from VMDK to VDI):l
  # config.disksize.size = "50GB"

  # # https://github.com/dotless-de/vagrant-vbguest/issues/335
  # if Vagrant.has_plugin?("vagrant-vbguest")
  #   config.vbguest.auto_update = false
  # end
  # set auto_update to false, if you do NOT want to check the correct 
  # additions version when booting this machine
  config.vbguest.auto_update = true

  # https://github.com/tmatilai/vagrant-timezone
  if Vagrant.has_plugin?("vagrant-timezone")
    config.timezone.value = :host
  end

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    vb.memory = 2048
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional', '--graphicscontroller', 'vmsvga']
  end

  # UI Ressources: Themes, Wallpapers
  config.vm.provision "file", source: "data/Mate_M013_4K.png", destination: ".local/share/wallpapers/Mate_M013_4K.png"
  config.vm.provision "file", source: "data/Nordic-darker.tar.xz", destination: "/tmp/Nordic-darker.tar.xz"
  config.vm.provision "file", source: "data/Zafiro-Icons.tar.xz", destination: "/tmp/Zafiro-Icons.tar.xz"
  #
  config.vm.provision "file", source: "scripts/.post-init.sh", destination: "/home/vagrant/.post-init.sh"
  #
  config.vm.provision "shell", privileged: false, path: "scripts/full-install.sh"  
  #
  config.vm.provision "file", source: "dotfile/.profile", destination: "/home/vagrant/.profile"
  config.vm.provision "file", source: "dotfile/.gitconfig", destination: "/home/vagrant/.gitconfig"
  config.vm.provision "file", source: "dotfile/.zshrc", destination: "/home/vagrant/.zshrc"
  config.vm.provision "file", source: "dotfile/.tmux.conf.local", destination: "/home/vagrant/.tmux.conf.local"  
  config.vm.provision "file", source: "dotfile/.powerlevel9k", destination: "/home/vagrant/.powerlevel9k"
  config.vm.provision "file", source: "dotfile/alacritty.yml", destination: "/home/vagrant/.config/alacritty/alacritty.yml"
  config.vm.provision "file", source: "dotfile/dconf.ini", destination: "/home/vagrant/.config/dconf/dconf.ini"
  config.vm.provision "file", source: "dotfile/rc.conf", destination: "/home/vagrant/.config/ranger/rc.conf"
end
