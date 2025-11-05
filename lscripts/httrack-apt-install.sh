#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## HTTrack - bulk download site, site scraper
###----------------------------------------------------------
#
## References:
## * http://www.httrack.com/page/2/en/index.html
###----------------------------------------------------------

set -e

function httrack-apt-install.main() {
  echo ">>> Installing HTTrack..."
  sudo apt update -y >/dev/null 2>&1
  sudo apt install -y httrack >/dev/null 2>&1
}

httrack-site-clone.main "$@"
