##########################
#
#     /\   |  __ |__   __|
#    /  \  | |__) | | |
#   / /\ \ |  ___/  | |
#  / ____ \| |      | |
# /_/    \_|_|      |_|
#
##########################
figlet "APT: FULL"
sudo apt-get -y --fix-broken install &&
    sudo apt-get update &&
    sudo apt-get -y upgrade &&
    sudo apt-get -y dist-upgrade &&
    sudo apt-get -y autoremove --purge &&
    sudo apt-get -y autoclean
