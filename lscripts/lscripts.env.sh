#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts environment configuration 
###----------------------------------------------------------


function lsd-lscripts.env.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/core/config/ps1.sh"

  source "${LSCRIPTS}/lscripts.export.sh"
  lsd-mod.lscripts.export "$@"

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

# [[ -z lsd-lscripts.install.main ]] || {
#   (>&2 echo -e "
#      _       _____  _____ _____  _____ _____ _______ _____ 
#     | |     / ____|/ ____|  __ \|_   _|  __ \__   __/ ____|
#     | |    | (___ | |    | |__) | | | | |__) | | | | (___  
#     | |     \___ \| |    |  _  /  | | |  ___/  | |  \___ \ 
#     | |____ ____) | |____| | \ \ _| |_| |      | |  ____) |
#     |______|_____/ \_____|_|  \_\_____|_|      |_| |_____/ 
#     >>> Execute following to initialise 'lscripts'
#     $(echo -e 'lsd-lscripts.env.main "$@"')

#     ")
# }
