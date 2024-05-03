#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## key value parser for shell script for bash shell with help menu
#
## @Reference: lscripts/tests/test.argparse-menu.sh
## @Example: lsd-virtualbox.create-vm --help
##----------------------------------------------------------


declare -A args


## manu - minus, alpha, numberic, underscore; they are preserved
function lsd-mod.argparse.manu() {
  ## only alpha-numeric values are allowed
  # [[ ! -z $1 ]] && (>&2 echo -e $(tr -dc '0-9a-zA-Z' <<< "$1"));
  [[ ! -z $1 ]] && echo $(tr -dc '0-9a-zA-Z_-' <<< "$1" | tr '[:upper:]' '[:lower:]');
}


function lsd-mod.argparse.normalize-key() {
  ## normalize keys to only alpha-numeric and lowercase characters
  local key="$1"
  echo $(lsd-mod.argparse.manu "${key}")
}


function lsd-mod.argparse.help-menu() {
  ## Generate help menu dynamically based on JSON data
  local json_data="$1"
  local options_keys=()

  # Parse JSON data to get option keys and their descriptions
  IFS=$'\n' read -r -d '' -a options_keys < <(jq -r 'keys[]' <<< "$json_data")

  lsd-mod.log.echo "${whi}Usage: [OPTIONS]${nocolor}"
  lsd-mod.log.echo
  lsd-mod.log.echo "${whi}Options:${nocolor}"

  for key in "${options_keys[@]}"; do
    local description=$(jq -r ".\"$key\".description" <<< "$json_data")  # Enclose the key in double quotes
    local opt=$(jq -r ".\"$key\".opt" <<< "$json_data")  # Enclose the key in double quotes
    local default=$(jq -r ".\"$key\".default" <<< "$json_data")  # Enclose the key in double quotes
    local required=$(jq -r ".\"$key\".required" <<< "$json_data")  # Enclose the key in double quotes

    local default_str="(${yel}default: ${default}${nocolor})"
    if [[ "$required" == "true" ]]; then
      default_str="(${red}required${nocolor})"
    fi

    ## Normalize the key
    local _key=$(lsd-mod.argparse.normalize-key "${key}")

    lsd-mod.log.echo "${whi}-${opt}, --${_key}, ${description} ${default_str}${nocolor}"
  done
}


function lsd-mod.parse_args() {
  local _cmd=jq
  type ${_cmd} &>/dev/null || {
    lsd-mod.log.error "jq utility is needed but not installed."
    exit 1
  }

  ## Parse command-line arguments and generate help menu
  local json_data="$1"
  local _key
  local _val
  local _opt
  local _default
  local _dtype
  local options_keys=()

  # Parse JSON data to get option keys and their defaults
  IFS=$'\n' read -r -d '' -a options_keys < <(jq -r 'keys[]' <<< "$json_data")

  # (>&2 echo -e "Total::$#")
  ## (>&2 echo -e "::::options_keys: ${options_keys[@]}")
 
  ## Check if the help option is provided
  for arg in "$@"; do
    if [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
      # Generate and print the help menu
      lsd-mod.argparse.help-menu "$json_data"
      exit 0
    fi
  done

  for key in "${options_keys[@]}"; do
    _opt=$(jq -r ".\"$key\".opt" <<< "$json_data")  # Enclose the key in double quotes
    _default=$(jq -r ".\"$key\".default" <<< "$json_data")  # Enclose the key in double quotes
    _dtype=$(jq -r ".\"$key\".dtype" <<< "$json_data")  # Enclose the key in double quotes

    ## Normalize the key
    _key=$(lsd-mod.argparse.normalize-key "$key")

    ## (>&2 echo -e "::::key: ${key}")
    ## (>&2 echo -e "::::_opt: ${_opt}")
    ## (>&2 echo -e "::::_default: ${_default}")

    while [[ "$#" > "1" ]]; do
      shift
      # (>&2 echo -e "----------------:: $1")
      case "$1" in 
        (*=*)
            _key="${1%%=*}" &&  _key="${_key/--/}" && _val="${1#*=}"
            args[${_key}]="${_val}"
            # (>&2 echo -e "key:val => ${_key}:${_val}")
            ;;
        (--*)
            _key="${1--%%*}" &&  _key="${_key/--/}" && _val=1
            args[${_key}]="${_val}"
            [[ -n "${_dtype}" && "${_dtype}" != "bool" ]] && {
              lsd-mod.log.error "--${_key} requires a value."
              lsd-mod.argparse.help-menu "$json_data"
              exit 1
            }
            # (>&2 echo -e "key:val => ${_key}:${_val}")
            ;;
      esac
      # (>&2 echo -e ";;;")
    done

    ## If the option is not present, set the default value
    if [[ -z "${args[${_key}]}" && "${_default}" != "null" ]]; then
      args["${_key}"]="${_default}"
    fi

    ## Check if the option is required and not provided
    if [[ "${args[${_key}]}" == "" && $(jq -r ".\"$key\".required" <<< "$json_data") == "true" ]]; then
      lsd-mod.log.error "Required parameter --${_key} is  missing."
      lsd-mod.argparse.help-menu "$json_data"
      exit 1
    fi
  done

}


# Call the lsd-mod.parse_args function with provided JSON data and command-line arguments
lsd-mod.parse_args "$@"
