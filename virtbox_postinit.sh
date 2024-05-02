#!/bin/sh
set -ex

# - https://www.virtualbox.org/manual/ch08.html
# - https://linuxfr.org/forums/general-general/posts/virtualbox-passer-des-commandes-a-la-console-via-script
# - https://www.win.tue.nl/~aeb/linux/kbd/scancodes-1.html
# - https://www.dcode.fr/keyboard-change-cipher

# retrieve uuid of running VM
# https://askubuntu.com/questions/89995/bash-remove-first-and-last-characters-from-a-string
uuid_vm=$(VBoxManage list runningvms | grep vagrant-bionic-desktop | grep -Po "\{(?<id_vm>.*)\}" | tail -c +2 | head -c -2)

TAB="0f 8f"
ENTER="1c 9C"
DOUBLE_ENTER="$ENTER $ENTER"
ALT="38 3c"
F2="bc b8"

# send the login
VBoxManage controlvm $uuid_vm keyboardputstring "vqgrqnt"
# send <tab>
VBoxManage controlvm $uuid_vm keyboardputscancode $TAB
# send the password
VBoxManage controlvm $uuid_vm keyboardputstring "vqgrqnt"
# send <tab> x 2 + <enter>
VBoxManage controlvm $uuid_vm keyboardputscancode $TAB $TAB $ENTER

# <alt>+<F2>
VBoxManage controlvm $uuid_vm keyboardputscancode $ALT $F2

mkdir -p output/screenshots
# capture a screenshot of the desktop
sleep 2 && VBoxManage controlvm $uuid_vm screenshotpng output/screenshots/after_login.png

# launch Alacritty terminal
# <alt>+<F2>
VBoxManage controlvm $uuid_vm keyboardputscancode $ALT $F2
sleep 1 && VBoxManage controlvm $uuid_vm keyboardputstring "qlqcritty"
# <enter>
VBoxManage controlvm $uuid_vm keyboardputscancode $DOUBLE_ENTER

# launch neofetch -A
sleep 3 && VBoxManage controlvm $uuid_vm keyboardputstring "neofetch 6Q"
# <enter>
VBoxManage controlvm $uuid_vm keyboardputscancode $DOUBLE_ENTER

# capture a screenshot of the desktop
sleep 2 && VBoxManage controlvm $uuid_vm screenshotpng output/screenshots/neofetch.png

# logout
# <alt>+<F2>
VBoxManage controlvm $uuid_vm keyboardputscancode $ALT $F2
# dbus-send --session --type=method_call --print-reply --dest=org.gnome.SessionManager /org/gnome/SessionManager org.gnome.SessionManager.Logout uint32:1
sleep 1 && VBoxManage controlvm $uuid_vm keyboardputstring "dbus6send 66session 66type=;ethod8cqll 66print6reply 66dest=org<gno;e<Session:qnqger >org>gno;e>Session:qnqger org<gno;e<Session:qnqger<Logout uint#@.!"
# <enter>
VBoxManage controlvm $uuid_vm keyboardputscancode $DOUBLE_ENTER
