#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell script core/lsd-mod.dir.sh module
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test.lsd-mod.dir.case-1() {
  declare -a _lsd_data_dirs_paths=($(lsd-mod.dir.get-datadirs-paths))
  local i
  for i in ${!_lsd_data_dirs_paths[*]}; do
    lsd-mod.log.echo "${gre}${_lsd_data_dirs_paths[$i]}"
  done
}


function test.lsd-mod.dir.case-2() {
  declare -a _lsd_os_dirs_paths=($(lsd-mod.dir.get-osdirs-paths))
  local i
  for i in ${!_lsd_os_dirs_paths[*]}; do
    lsd-mod.log.echo "${_lsd_os_dirs_paths[$i]}"
  done
}


function test.lsd-mod.dir.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  export LSCRIPTS__LOG_LEVEL=7 ## DEBUG
  test.lsd-mod.dir.case-1
  test.lsd-mod.dir.case-2
}


test.lsd-mod.dir.main
