#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell script utils/_dir_.sh module
###----------------------------------------------------------


trap ctrlc_handler INT

## trap 'exit 0' INT or simply trap INT 
function ctrlc_handler {
  (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
  exit
}


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test._dir_.case-1() {
  declare -a _lsd_data_dirs_paths=($(_dir_.get_lsd_data_dirs_paths))
  local i
  for i in ${!_lsd_data_dirs_paths[*]}; do
    _log_.echo "${gre}${_lsd_data_dirs_paths[$i]}"
  done
}


function test._dir_.case-2() {
  declare -a _lsd_os_dirs_paths=($(_dir_.get_lsd_os_dirs_paths))
  local i
  for i in ${!_lsd_os_dirs_paths[*]}; do
    _log_.echo "${_lsd_os_dirs_paths[$i]}"
  done
}


function test._dir_.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  export _LSCRIPTS__LOG_LEVEL_=7 ## DEBUG
  test._dir_.case-1
  test._dir_.case-2
}


test._dir_.main
