#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## youtube-dl ytd-gtk - youtube downloader
###----------------------------------------------------------
#
## References
## * https://www.lifewire.com/download-youtube-videos-p2-2202105
###----------------------------------------------------------


function youtubedl-apt-install.main() {
  sudo apt -y install youtube-dl
  ## not yet available for Ubuntu 18.04 LTS
  sudo apt -y install ytd-gtk
}

youtubedl-apt-install.main "$@"
