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

RUN . scripts/.tools.sh

RUN . scripts/install-apt-full.sh
RUN . scripts/install-flatpak.sh
RUN . scripts/install-common.sh
# . scripts/install-desktop.sh
RUN . scripts/install-python.sh
RUN . scripts/install-git.sh
RUN . scripts/install-cli.sh
RUN . scripts/install-audio_video.sh
RUN . scripts/install-communication_news.sh
RUN . scripts/install-utilities.sh
RUN . scripts/install-graphics_photography.sh
RUN . scripts/install-windows_manager.sh
RUN . scripts/install-dconf.sh
# . scripts/install-system.sh
RUN .  scripts/install-system-and-tools.sh
# installation doesn't work with debian 12 (on virtual machine) 
# . scripts/install-virtualbox.sh
RUN .  scripts/install-ide.sh
RUN .  scripts/install-fonts.sh
# System has not been booted with systemd as init system (PID 1). Can't operate.
# Failed to connect to bus: Host is down
# RUN .  scripts/install-keyboard.sh
# . scripts/install-nfs_synology.sh
# RUN .  scripts/install-post_init.sh
