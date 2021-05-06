#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## yarn
###----------------------------------------------------------
#
## Reference:
## * https://yarnpkg.com/lang/en/docs/install/#debian-stable
## * https://code.facebook.com/posts/1840075619545360
###----------------------------------------------------------


function yarn-install() {
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

  sudo apt -y update && sudo apt -y install yarn
}

yarn-install
