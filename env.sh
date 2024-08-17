#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts bashrc configuration 
###----------------------------------------------------------


function lsd-lscripts.env() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/export.main.sh"
  source "${LSCRIPTS}/export.alias.sh"


  ## respect local if exists; but *.local files will never be inside repos
  [ -f ${LSCRIPTS}/export.main.local.sh ] && source ${LSCRIPTS}/export.main.local.sh
  [ -f ${LSCRIPTS}/export.alias.local.sh ] && source ${LSCRIPTS}/export.alias.local.sh
  [ -f ${LSCRIPTS}/export.github.local.sh ] && source ${LSCRIPTS}/export.github.local.sh

}

lsd-lscripts.env
