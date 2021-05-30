#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## go
###----------------------------------------------------------
#
## References:
## * https://golang.org/doc/install
## * https://linuxconfig.org/install-go-on-ubuntu-18-04-bionic-beaver-linux
###----------------------------------------------------------


function golang-install.main() {
  ## 1. Install Go using Golang installer

  ## 2. Install Go from Ubuntu repostiory - Preferred
  sudo apt -y install golang
  go version

  ## 3. Install Go using snap
}

golang-install.main "$@"
