#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## encryption utilities
###----------------------------------------------------------
#
## References:
## * https://www.howtogeek.com/115955/how-to-quickly-encrypt-removable-storage-devices-with-ubuntu/
###----------------------------------------------------------
## WARNING
###----------------------------------------------------------
## * uses LUKS (Linux Unified Key Setup) encryption
## * encryption process will format the drive, deleting all data on it
## * encryption, which may not be compatible with other operating systems
## * he drive will be plug-and-play with any Linux system running the GNOME desktop
###----------------------------------------------------------


function encryption-apt-install.main() {
  ##sudo apt -y update
  sudo apt -y install cryptsetup
}

encryption-apt-install.main "$@"
