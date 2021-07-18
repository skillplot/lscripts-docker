#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## typeformats utility functions
###----------------------------------------------------------


function _typeformats_.get__vars() {
  # local nocolor='\e[0m';
  # local bgre='\e[1;32m';

  _log_.echo "__TIMESTAMP__: ${bgre}${__TIMESTAMP__}${nocolor}"
  _log_.echo "_BANNER_: ${bgre}${_BANNER_}${nocolor}"
  _log_.echo "_SHEBANG_: ${bgre}${_SHEBANG_}${nocolor}"
  _log_.echo "_COPYRIGHT_: ${bgre}${_COPYRIGHT_}${nocolor}"
}
