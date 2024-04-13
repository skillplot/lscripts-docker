#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## HTTrack - bulk download site, site scraper
###----------------------------------------------------------
#
## References:
## * http://www.httrack.com/page/2/en/index.html
###----------------------------------------------------------


function httrack-apt-install.main() {
  #sudo apt-get -y update
  #sudo apt-get -q -y remove vim vim-gtk && sudo apt-get -y autoremove
  sudo apt install -y webhttrack
}

httrack-apt-install.main "$@"
