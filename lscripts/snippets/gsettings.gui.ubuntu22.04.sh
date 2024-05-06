#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Credit:
## * https://askubuntu.com/a/1373539
###----------------------------------------------------------

nautilus -q
systemctl --user stop gvfs-metadata.service
rm ~/.local/share/gvfs-metadata/home*

columns="['name', 'size', 'date_modified']"
columns="['name', 'date_modified_with_time', 'size', 'type', 'permissions', 'owner', 'group', 'date_modified', 'date_accessed', 'date_created',  'where', 'starred']"

gsettings get org.gnome.nautilus.list-view default-visible-columns
gsettings get org.gnome.nautilus.list-view default-column-order

gsettings set org.gnome.nautilus.list-view default-visible-columns "${columns}"
gsettings set org.gnome.nautilus.list-view default-column-order "${columns}"

## battery indicator settings
gsettings set org.gnome.desktop.interface show-battery-percentage true
# gsettings set org.gnome.desktop.interface show-battery-percentage false

## date/time settings

## Show seconds in the clock
## Show day in the clock
## Show month in the clock
## Show week in the clock
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-day true
gsettings set org.gnome.desktop.interface clock-show-month true
gsettings set org.gnome.desktop.interface clock-show-weekday true

## To revert these changes, you can set the corresponding options to false:
gsettings set org.gnome.desktop.interface clock-show-seconds false
gsettings set org.gnome.desktop.interface clock-show-day false
gsettings set org.gnome.desktop.interface clock-show-month false
gsettings set org.gnome.desktop.interface clock-show-weekday false

## Do not disturb

## Enable Do Not Disturb mode
gsettings set org.gnome.desktop.notifications show-banners false
## Disable Do Not Disturb mode
gsettings set org.gnome.desktop.notifications show-banners true


## To disable notifications altogether in GNOME Shell from the command line, you can use the gsettings command to set the enable key under the org.gnome.desktop.notifications schema to false. Here's how you can do it:

# Disable notifications completely
dconf write /org/gnome/desktop/notifications/application-blacklist "['*']"

dconf reset /org/gnome/desktop/notifications/application-blacklist

# Get the application blacklist
dconf read /org/gnome/desktop/notifications/application-blacklist

# Get the notification whitelist
dconf read /org/gnome/desktop/notifications/application-whitelist

