#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='latex.md'
###----------------------------------------------------------
## TeX-LaTeX Editors
###----------------------------------------------------------
#
## References:
## * https://itsfoss.com/latex-editors-linux/
##----------------------------------------------------------


function latex-editors-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## Todo:: check latex is installed or not, otherwise install latex first
  sudo apt -y install texmaker
  sudo apt -y install lyx
  sudo apt -y install texstudio
  sudo apt -y install kile
  sudo apt -y install gummi
  sudo apt -y install gedit-latex-plugin
  sudo apt -y install texworks
}

latex-editors-apt-install.main "$@"
