#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## krita - graphics, image
###----------------------------------------------------------
#
## References:
## * https://krita.org/en/download/krita-desktop/
###----------------------------------------------------------


function krita-ppa-install.main() {
  sudo add-apt-repository -y ppa:kritalime/ppa
  sudo apt -y update
  sudo apt -y install krita

  ## If you also want to install translations:
  # sudo apt -y install krita-l10n
}

krita-ppa-install.main "$@"
