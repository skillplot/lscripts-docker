#!/bin/bash


# gsettings reset org.gnome.settings-daemon.plugins.color night-light-enabled
# gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-automatic
# gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-from
# gsettings reset org.gnome.settings-daemon.plugins.color night-light-schedule-to
# gsettings reset org.gnome.settings-daemon.plugins.color night-light-temperature

# journalctl -xe | grep color

# sudo apt-get install --reinstall gnome-settings-daemon


# gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
# gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic false
# gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-from 0.0
# gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-to 24.0
# gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4000

# sudo apt install redshift redshift-gtk
# sudo apt --fix-broken install

# redshift -x

# redshift -O 6000 -m randr -g 0.8:0.7:0.8

# redshift -O 3500 -m randr -g 1:1:0.8

redshift -O 3500 -m randr -g 1:1:0.8
redshift -O 3000 -m randr -g 1:0.9:0.7
