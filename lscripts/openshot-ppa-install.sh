#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## openshot - Video Editor
###----------------------------------------------------------
#
## References:
## * https://www.openshot.org/
## * https://www.openshot.org/ppa/
###----------------------------------------------------------


function openshot-ppa-install.main() {
  sudo add-apt-repository -y ppa:openshot.developers/ppa
  sudo apt -y update
  sudo apt -y install openshot-qt
}

openshot-ppa-install.main
