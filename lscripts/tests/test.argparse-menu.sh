#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test::shell script core/argparse-menu.sh
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test.argparse-menu.case-1() {
  local json_data='
  {
    "vm_name":{
      "description": "Virtual machine name (default: skplt-vm-$(date +'%d%m%y_%H%M%S'))",
      "opt": "n",
      "default": "skplt-vm-'$(date -d now +'%d%m%y_%H%M%S')'",
      "required": false
    },
    "os_type":{
      "description": "Operating system type (default: Linux_64)",
      "opt": "o",
      "default": "Linux_64",
      "required": false
    },
    "memory":{
      "description": "Memory size in MB (default: 2048)",
      "opt": "m",
      "default": "2048",
      "required": false
    },
    "iso_path":{
      "description": "Path to ISO file (mandatory)",
      "opt": "i",
      "default": null,
      "required": true
    }
  }'


  source "${LSCRIPTS}/../core/argparse-menu.sh" "$json_data" "$@"

  echo "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && echo "${key}=${args[${key}]}" || echo "Key does not exists: ${key}"
  done
}


function test.argparse-menu.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  export LSCRIPTS__LOG_LEVEL=7 ## DEBUG
  # test.argparse-menu.case-1 --user='blah' --group='dummy' --uid=1111 --gid=0000
  # test.argparse-menu.case-1
  # test.argparse-menu.case-1 --iso_path=a
  # test.argparse-menu.case-1 --iso_path=blah
  # test.argparse-menu.case-1 --vm-name=myname --memory=1024  iso-path=somepath --asd=zzz
  # test.argparse-menu.case-1 --vm-name=myname --memory=1024  --iso-path=somepath --asd=zzz
  test.argparse-menu.case-1
}


test.argparse-menu.main
