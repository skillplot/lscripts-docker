#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## VLC
###----------------------------------------------------------


function vlc-apt-install.main() {
  # sudo apt -y update
  sudo apt -y install vlc
  # sudo apt -y install vlc browser-plugin-vlc

  # VLC hacks

  ##----------------------------------------------------------
  ### Opening the CAM out of the box
  ##----------------------------------------------------------
  # vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio
}

vlc-apt-install.main "$@"
