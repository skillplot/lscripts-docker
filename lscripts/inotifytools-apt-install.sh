#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## inotify tools
###----------------------------------------------------------
#
## References:
## * https://developer.ibm.com/tutorials/l-ubuntu-inotify/
## * https://pypi.org/project/inotify/
#
## `apt-cache search inotify`
###----------------------------------------------------------


function inotifytools-apt-install.main() {
  sudo apt -y install inotify-tools
}

inotifytools-apt-install.main
