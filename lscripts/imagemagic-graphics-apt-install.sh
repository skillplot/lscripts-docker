#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## imagemagick
###----------------------------------------------------------
#
## References:
## * https://www.theshell.guru/install-imagemagick-ubuntu-16-04/
###----------------------------------------------------------


function imagemagic-graphics-apt-install.main() {
  ## Don't remove image magic - imagemagick may be a dependency for other pieces of software run
  ## sudo apt remove --purge imagemagick
  apt-cache showpkg imagemagick
  sudo apt -y update
  sudo apt -y install imagemagick
  sudo apt -y install graphicsmagick
  ## for php
  sudo apt -y install php-imagick
}

imagemagic-graphics-apt-install.main "$@"
