#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Lscripts utilities and softwares
###----------------------------------------------------------


function core-apt-install.main() {
  ## sudo apt -y update
  ## Essential for New Machine Setup
  sudo apt -y install -y --no-install-recommends \
    build-essential \
    apt-transport-https \
    ca-certificates \
    gnupg \
    gnupg2 \
    wget \
    curl \
    software-properties-common
}

core-apt-install.main "$@"
