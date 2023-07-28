#!/bin/sh
set -ex

figlet "FlatPak"
sudo flatpak install -y flathub \
	org.signal.Signal \
	com.github.IsmaelMartinez.teams_for_linux \
	com.discordapp.Discord \
	com.spotify.Client \
	com.brave.Browser

echo 'flatpak run org.signal.Signal "$@"' > $HOME/.local/bin/signal-desktop && \
chmod +x $HOME/.local/bin/signal-desktop

echo 'flatpak run com.github.IsmaelMartinez.teams_for_linux "$@"' > $HOME/.local/bin/teams && \
chmod +x $HOME/.local/bin/teams

echo 'flatpak run com.discordapp.Discord "$@"' > $HOME/.local/bin/discord && \
chmod +x $HOME/.local/bin/discord

echo 'flatpak run com.spotify.Client "$@"' > $HOME/.local/bin/spotify && \
chmod +x $HOME/.local/bin/spotify

echo 'flatpak run com.brave.Browser "$@"' > $HOME/.local/bin/brave-browser && \
chmod +x $HOME/.local/bin/brave-browser

set +ex
