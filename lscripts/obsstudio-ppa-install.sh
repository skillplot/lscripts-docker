#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## obs-studio, video,cam streaming
###----------------------------------------------------------
#
## References:
## * https://obsproject.com/
## * https://github.com/obsproject/obs-studio/wiki/Install-Instructions#linux
###----------------------------------------------------------


function obsstudio-ppa-install() {
  sudo add-apt-repository -y ppa:obsproject/obs-studio
  sudo apt -y update
  sudo apt -y install obs-studio
}

obsstudio-ppa-install
