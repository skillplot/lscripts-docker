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
