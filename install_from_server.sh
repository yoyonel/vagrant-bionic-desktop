#!/bin/sh
set -ex

# UI Ressources: Themes, Wallpapers
mkdir -p $HOME/.local/share/wallpapers
cp "data/Mate_M013_4K.png" "$HOME/.local/share/wallpapers/Mate_M013_4K.png"
cp "data/Nordic-darker.tar.xz" "/tmp/Nordic-darker.tar.xz"
cp "data/Zafiro-Icons.tar.xz" "/tmp/Zafiro-Icons.tar.xz"
cp "scripts/.post-init.sh" "$HOME/.post-init.sh"

sh "scripts/full-install.sh"

cp "dotfile/.profile" "$HOME/.profile"
cp "dotfile/.gitconfig" "$HOME/.gitconfig"
cp "dotfile/.zshrc" "$HOME/.zshrc"
cp "dotfile/.tmux.conf.local" "$HOME/.tmux.conf.local"  
cp "dotfile/.powerlevel9k" "$HOME/.powerlevel9k"
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/dconf"
mkdir -p "$HOME/.config/ranger"
cp "dotfile/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
cp "dotfile/dconf.ini" "$HOME/.config/dconf/dconf.ini"
cp "dotfile/rc.conf" "$HOME/.config/ranger/rc.conf"
