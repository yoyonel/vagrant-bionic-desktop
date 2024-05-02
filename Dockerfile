FROM debian:latest

# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
ARG USERNAME=vagrant
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Use "bash" as replacement for	"sh"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
WORKDIR /home/$USERNAME

COPY scripts /home/$USERNAME/scripts
COPY data /home/$USERNAME/data
#
COPY full-install.sh /home/$USERNAME/full-install.sh
COPY install_from_server.sh /home/$USERNAME/install_from_server.sh

RUN mkdir -p .local/share/wallpapers

RUN . scripts/.pre-init.sh
RUN . scripts/install-apt-full.sh

RUN source scripts/.tools.sh && . scripts/install-flatpak.sh
RUN . scripts/install-common.sh
# . scripts/install-desktop.sh
RUN source scripts/.tools.sh && . scripts/install-python.sh
RUN source scripts/.tools.sh && . scripts/install-git.sh
RUN source scripts/.tools.sh && . scripts/install-cli.sh
RUN source scripts/.tools.sh && . scripts/install-audio_video.sh
RUN source scripts/.tools.sh && . scripts/install-communication_news.sh
RUN source scripts/.tools.sh && . scripts/install-utilities.sh
RUN source scripts/.tools.sh && . scripts/install-graphics_photography.sh
RUN source scripts/.tools.sh && . scripts/install-windows_manager.sh
RUN source scripts/.tools.sh && . scripts/install-dconf.sh
# . scripts/install-system.sh
RUN source scripts/.tools.sh && . scripts/install-system-and-tools.sh
# installation doesn't work with debian 12 (on virtual machine) 
# . scripts/install-virtualbox.sh
RUN source scripts/.tools.sh && . scripts/install-ide.sh
RUN source scripts/.tools.sh && . scripts/install-fonts.sh
# System has not been booted with systemd as init system (PID 1). Can't operate.
# Failed to connect to bus: Host is down
# RUN .  scripts/install-keyboard.sh
# . scripts/install-nfs_synology.sh
# RUN .  scripts/install-post_init.sh

COPY scripts/check-versions.sh /home/$USERNAME/check-versions.sh

COPY "dotfile/.profile" "/home/vagrant/.profile"
COPY "dotfile/.gitconfig" "/home/vagrant/.gitconfig"
COPY "dotfile/.zshrc" "/home/vagrant/.zshrc"
# # COPY "dotfile/.tmux.conf" "/home/vagrant/.tmux.conf.local"
# COPY "dotfile/.powerlevel9k" "/home/vagrant/.powerlevel9k"
COPY "dotfile/alacritty.yml" "/home/vagrant/.config/alacritty/alacritty.yml"
# COPY "dotfile/dconf.ini" "/home/vagrant/.config/dconf/dconf.ini"
# COPY "dotfile/rc.conf" "/home/vagrant/.config/ranger/rc.conf"

RUN if [ ! -d /home/vagrant/.oh-my-zsh/custom/themes/powerlevel10k ]; then git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/vagrant/.oh-my-zsh/custom/themes/powerlevel10k; fi
    # && sed -i.bak 's/powerlevel9k/powerlevel10k/g' ~/.zshrc

COPY "dotfile/.p10k.zsh" "/home/vagrant/.p10k.zsh"
