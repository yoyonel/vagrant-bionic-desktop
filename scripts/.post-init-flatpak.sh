#!/bin/sh
set -ex

figlet "FlatPak"
sudo flatpak install -y flathub \
	org.signal.Signal \
	com.github.IsmaelMartinez.teams_for_linux \
	com.discordapp.Discord \
	com.spotify.Client

set +ex
