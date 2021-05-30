#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## MySQL
###----------------------------------------------------------
#
## References:
## * https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-16-04
###----------------------------------------------------------


function mysql-apt-install.main() {
  # sudo apt -y update
  sudo apt -y install mysql-server
}

mysql-apt-install.main "$@"
