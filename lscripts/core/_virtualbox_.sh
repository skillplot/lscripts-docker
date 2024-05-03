#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## virtualbox vm Utility Functions
###----------------------------------------------------------



function lsd-mod.virtualbox.get__vars() {
  lsd-mod.log.echo "virtualbox:TBD: ${bgre}TBD${nocolor}"
}

function lsd-mod.virtualbox.create-vm() {
  local json_data='
  {
    "vm_name":{
      "description": "Virtual machine name",
      "opt": "n",
      "default": "skplt-vm-'$(date -d now +'%d%m%y_%H%M%S')'",
      "required": false
    },
    "os_type":{
      "description": "Operating system type",
      "opt": "o",
      "default": "Linux_64",
      "required": false
    },
    "memory":{
      "description": "Memory size in MB",
      "opt": "m",
      "default": "2048",
      "required": false
    },
    "iso_path":{
      "description": "Path to ISO file",
      "opt": "i",
      "default": null,
      "required": true
    }
  }'


  source "${LSCRIPTS}/core/argparse-menu.sh" "$json_data" "$@"

  # lsd-mod.log.echo "Total: $# should be equal to ${#args[@]} and args: ${args[@]}"
  lsd-mod.log.echo "Total: $#"

  local key
  for key in "${!args[@]}"; do
    [[ -n "${args[${key}]+1}" ]] && lsd-mod.log.echo "${key}=${args[${key}]}" || lsd-mod.log.echo "Key does not exists: ${key}"
  done

  lsd-mod.log.echo "Coming soon..."
}
