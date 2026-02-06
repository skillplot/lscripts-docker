#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
## __author__ = 'mangalbhaskar'
##----------------------------------------------------------
## argparse-v2.sh
##
## Backward-compatible key=value parser
## + boolean flag support (--flag)
##
## Supported forms:
##   --key=value
##   key=value
##   --flag            -> flag=true
##   --flag=true|false
##
## Explicitly NOT supported:
##   --key value       (to avoid ambiguity)
##----------------------------------------------------------

declare -A args
local _key _val

while [[ "$#" -gt 0 ]]; do
  case "$1" in

    ## --key=value OR key=value
    (*=*)
      _key="${1%%=*}"
      _key="${_key#--}"
      _val="${1#*=}"
      args["${_key}"]="${_val}"
      ;;

    ## --flag   → boolean true
    (--*)
      _key="${1#--}"
      args["${_key}"]="true"
      ;;

    ## ignore anything else (positional args unsupported by design)
    (*)
      ;;
  esac
  shift
done
