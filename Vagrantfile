Vagrant.configure("2") do |config|
  # https://app.vagrantup.com/archlinux/boxes/archlinux
  config.vm.box = "archlinux/archlinux"
    
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

  config.vm.provision "shell", privileged: false, path: "scripts/full-install.sh"
end
