#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## typeformats utility functions
###----------------------------------------------------------


function _typeformats_.get__vars() {
  _log_.echo "__TIMESTAMP__: \e[1;32m${__TIMESTAMP__}"
  _log_.echo "_BANNER_: \e[1;32m${_BANNER_}"
  _log_.echo "_SHEBANG_: \e[1;32m${_SHEBANG_}"
  _log_.echo "_COPYRIGHT_: \e[1;32m${_COPYRIGHT_}"
}
