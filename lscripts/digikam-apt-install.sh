#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## digikam - graphics, image
###----------------------------------------------------------


function digikam-apt-install.main() {
  sudo apt -y install digikam
}

digikam-apt-install.main "$@"
