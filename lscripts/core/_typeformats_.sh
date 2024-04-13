#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## typeformats utility functions
###----------------------------------------------------------


function lsd-mod.typeformats.get__vars() {
  # local nocolor='\e[0m';
  # local bgre='\e[1;32m';

  lsd-mod.log.echo "__TIMESTAMP__: ${bgre}${__TIMESTAMP__}${nocolor}"
  lsd-mod.log.echo "_BANNER_: ${bgre}${_BANNER_}${nocolor}"
  lsd-mod.log.echo "_SHEBANG_: ${bgre}${_SHEBANG_}${nocolor}"
  lsd-mod.log.echo "_COPYRIGHT_: ${bgre}${_COPYRIGHT_}${nocolor}"
}
