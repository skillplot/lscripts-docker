#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## heroku cli
##----------------------------------------------------------
#
## References:
## * https://devcenter.heroku.com/articles/heroku-cli#download-and-install
###----------------------------------------------------------


function heroku-cli-snap-install.main() {
  sudo snap install --classic heroku
}

heroku-cli-snap-install.main "$@"
