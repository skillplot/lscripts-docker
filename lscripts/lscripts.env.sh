#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts environment configuration 
###----------------------------------------------------------


function lsd-lscripts.env.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/config/ps1.sh"

  source "${LSCRIPTS}/lscripts.export.sh"

  source "${LSCRIPTS}/lscripts.install.sh"
  lsd-lscripts.install.main "$@"

  source "${LSCRIPTS}/lscripts.alias.sh"
  lsd-lscripts.alias.main "$@"
  # (>&2 echo -e "lscripts updated...")

  source "${LSCRIPTS}/banners/asciiart.sh"
  lsd-mod.asciiart.main "$@"

  source "${LSCRIPTS}/lscripts.exe.sh"
  lsd-lscripts.exe.main "$@"
}

lsd-lscripts.env.main "$@"
