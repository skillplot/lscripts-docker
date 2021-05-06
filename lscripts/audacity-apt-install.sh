#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## audacity
###----------------------------------------------------------
#
## References:
## * http://ubuntuhandbook.org/index.php/2015/04/install-audacity-audio-editor-2-1-0-in-ubuntu-from-ppa/
###----------------------------------------------------------


function audacity-apt-install() {
  ## Ubuntu 16.04
  # sudo add-apt-repository -y ppa:ubuntuhandbook1/audacity
  # sudo apt -y update
  # sudo apt -y install audacity

  ## Ubuntu 18.04
  sudo apt -y install audacity audacity-data
}

audacity-apt-install
