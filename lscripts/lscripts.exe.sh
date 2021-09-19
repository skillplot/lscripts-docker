#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Alias for system configurations and convenience utilities
###----------------------------------------------------------


function __lscripts_exe__() {
  local _LSCRIPTS__ALIAS_SH=$(lsd-dir.admin.mkalias-osdirs)
  # echo "_LSCRIPTS__ALIAS_SH: ${_LSCRIPTS__ALIAS_SH}"
  [[ -f ${_LSCRIPTS__ALIAS_SH} ]] && source "${_LSCRIPTS__ALIAS_SH}"
}

__lscripts_exe__
