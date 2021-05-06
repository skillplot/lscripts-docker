#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test for shell script logging module
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test-1-case-1-fio() {
  _fio_.yes_or_no_loop "Are you infected" && _log_.echo "Yes" || _log_.echo "No"
  _fio_.yesno_yes "Are you sure" && _log_.echo "Yes" || _log_.echo "No"
  _fio_.yesno_no "Think once again, are you sure" && _log_.echo "Yes" || _log_.echo "No"
}


function test-1-fio() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  export _fio__LEVEL_=7 ## DEBUG
  test-1-case-1-fio
}


test-1-fio
