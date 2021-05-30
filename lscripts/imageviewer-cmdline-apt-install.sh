#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Commandline Simple Image Viewers
###----------------------------------------------------------


function imageviewer-cmdline-apt-install.main() {
  sudo apt -y install feh
  sudo apt -y install geeqie
  sudo apt -y install fbi
  sudo apt -y install mirage
}

imageviewer-cmdline-apt-install.main "$@"
