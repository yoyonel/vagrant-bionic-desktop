#  _____   ____   _____ _______   _____ _   _ _____ _______
# |  __ \ / __ \ / ____|__   __| |_   _| \ | |_   _|__   __|
# | |__) | |  | | (___    | |______| | |  \| | | |    | |
# |  ___/| |  | |\___ \   | |______| | | . ` | | |    | |
# | |    | |__| |____) |  | |     _| |_| |\  |_| |_   | |
# |_|     \____/|_____/   |_|    |_____|_| \_|_____|  |_|
#
figlet "post-init"
[ -f $HOME/.post-init.sh ] && chmod +x $HOME/.post-init.sh
[ -f $HOME/.post-init-mate-theme.sh ] && chmod +x $HOME/.post-init-mate-theme.sh
[ -f $HOME/.post-init-flatpak.sh ] && chmod +x $HOME/.post-init-flatpak.sh
