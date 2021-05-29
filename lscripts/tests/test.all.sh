#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell scripts test.*.sh
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test.all.case-0() {
  # source ${LSCRIPTS}/test._dir_.sh
  # source ${LSCRIPTS}/test.echo.sh
  # source ${LSCRIPTS}/test._fio_.sh
  source ${LSCRIPTS}/test._system_.sh
  # source ${LSCRIPTS}/test.argparse.sh
  # source ${LSCRIPTS}/test.cuda_config_supported.sh
  # source ${LSCRIPTS}/test._log_.sh
}


function test.all.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  export _LSCRIPTS__LOG_LEVEL_=7 ## DEBUG
  test.all.case-0
}


test.all.main
