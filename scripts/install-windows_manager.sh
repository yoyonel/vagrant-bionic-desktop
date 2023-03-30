# __          ___           _                 __  __
# \ \        / (_)         | |               |  \/  |
#  \ \  /\  / / _ _ __   __| | _____      __ | \  / | __ _ _ __   __ _  __ _  ___ _ __
#   \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / / | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '__|
#    \  /\  /  | | | | | (_| | (_) \ V  V /  | |  | | (_| | | | | (_| | (_| |  __/ |
#     \/  \/   |_|_| |_|\__,_|\___/ \_/\_/   |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_|
#                                                                       __/ |
#                                                                      |___/
#
figlet "THEME: NORDIC"
if [ ! -d /usr/share/themes/Nordic-darker ]; then
	sudo mkdir -p /usr/share/themes/
	sudo tar -xf /tmp/Nordic-darker.tar.xz -C /usr/share/themes
fi

figlet "ICONS: ZAFIRO"
if [ ! -d /usr/share/icons/Zafiro-Icons ]; then
	sudo mkdir -p /usr/share/icons
	sudo tar -xf /tmp/Zafiro-Icons.tar.xz -C /usr/share/icons
fi

figlet "WALLPAPER"
# TODO: écrire le test de savoir si c'est déjà en place
ln -sf "$HOME/.local/share/wallpapers/Mate_M013_4K.png" "$HOME/.local/share/wallpapers/default.png"
