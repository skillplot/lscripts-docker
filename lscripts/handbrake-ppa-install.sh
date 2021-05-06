#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## handbrake - Video Converter/transcoder
###----------------------------------------------------------
#
## References:
## * https://handbrake.fr/
## * https://github.com/HandBrake
## * https://listoffreeware.com/free-open-source-video-converter-software-windows/
###----------------------------------------------------------


function handbrake-ppa-install() {
  sudo add-apt-repository -y ppa:stebbins/handbrake-releases
  sudo apt -y update
  sudo apt -y install handbrake handbrake-gtk handbrake-cli
}

handbrake-ppa-install
