#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## lyx - latex editor
###----------------------------------------------------------
#
## References:
## * https://wiki.lyx.org/LyX/LyXOnUbuntu#toc3
###----------------------------------------------------------


function lyx-ppa-install() {
  #sudo apt --remove lyx
  sudo add-apt-repository -y ppa:lyx-devel/release
  sudo apt -y update
  sudo apt -y install lyx
}

lyx-ppa-install
