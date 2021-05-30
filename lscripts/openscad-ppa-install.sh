#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## OpenScad - cad tool
###----------------------------------------------------------
#
## References:
## * http://www.openscad.org/
## * https://askubuntu.com/questions/327807/any-3d-cad-programs-for-ubuntu
#
## `sudo add-apt-repository -y  ppa:chrysn/openscad`
###----------------------------------------------------------


function openscad-ppa-install.main() {
  sudo add-apt-repository -y ppa:openscad/releases
  sudo apt -y update
  sudo apt -y install openscad
}

openscad-ppa-install.main "$@"
