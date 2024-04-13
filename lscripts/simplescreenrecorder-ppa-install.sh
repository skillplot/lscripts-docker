#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## simplescreenrecorder
###----------------------------------------------------------
#
## References:
## * https://askubuntu.com/questions/4428/how-can-i-record-my-screen
###----------------------------------------------------------


function simplescreenrecorder-ppa-install.main() {
  sudo add-apt-repository -y ppa:maarten-baert/simplescreenrecorder
  sudo apt -y update
  sudo apt -y install simplescreenrecorder

  ## if you want to record 32-bit OpenGL applications on a 64-bit system:
  #sudo apt-get install simplescreenrecorder-lib:i386
}

simplescreenrecorder-ppa-install.main "$@"
