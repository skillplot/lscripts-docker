#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='epub.md'
###----------------------------------------------------------
## epub readers
###----------------------------------------------------------
#
## References:
## * https://itsfoss.com/best-ebook-readers-linux/
###----------------------------------------------------------


function epub-readers-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## fbreader
  sudo apt -y install fbreader

  ## okular
  sudo apt -y install okular

  ## bookworm
  sudo apt-add-repository -y ppa:bookworm-team/bookworm
  sudo apt -y update
  sudo apt -y install com.github.babluboy.bookworm

  ## buka
  sudo snap -y install buka

  ## foliate
  ### ppa
  # sudo add-apt-repository -y ppa:apandada1/foliate
  # sudo apt -y update
  # sudo apt -y install foliate

  ### snapd
  ## sudo apt update
  ## sudo apt install snapd
  # sudo snap install foliate
}

epub-readers-apt-install.main
