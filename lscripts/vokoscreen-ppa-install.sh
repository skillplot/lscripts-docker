#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## vokoscreen - screen recorder
###----------------------------------------------------------
#
## References:
## * https://www.unixmen.com/vokoscreen-a-new-screencasting-tool-for-linux/
## * https://www.lifewire.com/create-video-tutorials-using-vokoscreen-screencasting-3958725
## * https://github.com/vkohaupt/vokoscreen
###----------------------------------------------------------


function vokoscreen-ppa-install.main() {
  sudo add-apt-repository -y ppa:vokoscreen-dev/vokoscreen
  #sudo apt-add-repository --remove ppa:vokoscreen-dev/vokoscreen
  sudo apt -y update
  sudo apt -y install vokoscreen
}

vokoscreen-ppa-install.main "$@"
