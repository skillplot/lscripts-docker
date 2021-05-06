#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts environment configuration 
###----------------------------------------------------------


function __lscripts_env__() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/utils/ps1.sh"
  ##
  ## Todo: for full configuration
  # source "${LSCRIPTS}/lscripts.export.sh"
  source "${LSCRIPTS}/lscripts.cmd.sh"
  source "${LSCRIPTS}/lscripts.alias.sh"
  # (>&2 echo -e "lscripts updated...")

  source "${LSCRIPTS}/banners/asciiart.sh"
  asciiart.skillplot_banner_1
}

__lscripts_env__
