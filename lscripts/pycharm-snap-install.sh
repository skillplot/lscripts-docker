#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## pycharm - Python IDE
###----------------------------------------------------------
#
## References:
## * https://www.ubuntu18.com/how-to-install-pycharm-on-ubuntu-18/
###----------------------------------------------------------


function pycharm-snap-install() {
  ##sudo apt -y update
  # sudo snap remove pycharm-community
  snap install pycharm-community --classic
  # snap install pycharm-professional --classic
}

pycharm-snap-install
