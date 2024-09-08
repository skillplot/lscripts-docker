sudo apt install libfuse2t64
sudo apt install ubuntu-restricted-extras
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

sudo apt install cheese

sudo apt install gdebi
sudo apt install synaptic
sudo apt install -y gdebi gimp vlc synaptic

sudo apt install timeshift


sudo snap remove firefox
cd ~/snap
rm -r firefox

sudo ubuntu-report -f send no


sudo apt install tlp


https://www.debugpoint.com/10-things-to-do-ubuntu-24-04-after-install/


sudo apt install fonts-roboto fonts-cascadia-code fonts-firacode


sudo apt update
sudo apt install gnome-tweaks
sudo apt install gnome-themes-extra

Ubuntu 24.04 uses GNOME 44 or later, which introduces several changes compared to GNOME 42 in Ubuntu 22.04

gnome-shell --version

gnome-control-center --version


switch windows of an application: Alt+`
switch applications: Alt+tab
switch windows: Disabled


'Ubuntu Desktop' -> Turn off enhanced tiling group

gsettings list-schemas
gsettings list-keys org.gnome.shell

gsettings get org.gnome.shell <key>
gsettings list-recursively org.gnome.desktop.keybindings


gsettings list-keys org.gnome.desktop.wm.keybindings

gsettings list-recursively org.gnome.desktop.wm.keybindings

gsettings list-recursively org.gnome.mutter.keybindings

gsettings list-recursively org.gnome.mutter.wayland.keybindings

gsettings list-recursively org.gnome.shell.keybindings

gsettings get org.gnome.desktop.wm.keybindings minimize

cat /etc/X11/default-display-manager
