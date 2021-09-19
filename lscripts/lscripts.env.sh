#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts environment configuration 
###----------------------------------------------------------


function __lscripts_env__() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/config/ps1.sh"
  ##
  ## Todo: for full configuration
  # source "${LSCRIPTS}/lscripts.export.sh"
  source "${LSCRIPTS}/lscripts.install.sh"
  lsd-mod.lscripts.install.main

  source "${LSCRIPTS}/lscripts.alias.sh"
  # (>&2 echo -e "lscripts updated...")

  source "${LSCRIPTS}/banners/asciiart.sh"
  lsd-mod.asciiart.main
  #
  source "${LSCRIPTS}/lscripts.exe.sh"
  lsd-mod.lscripts.exe.main
}

__lscripts_env__
