#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## freecad
###----------------------------------------------------------
#
## References:
## * https://www.freecadweb.org/wiki/Download
###----------------------------------------------------------


function freecad-ppa-install.main() {
  sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
  sudo apt update
  sudo apt -y install freecad-daily freecad-daily-doc 
}

freecad-ppa-install.main "$@"
