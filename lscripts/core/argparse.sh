#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## key value parser for shell script for bash shell

## Reference and Credits:
## http://tldp.org/LDP/abs/html/parameter-substitution.html
## https://stackoverflow.com/questions/14370133/is-there-a-way-to-create-key-value-pairs-in-bash-script#14371026
## https://stackoverflow.com/questions/5499472/specify-command-line-arguments-like-name-value-pairs-for-shell-script

## @Example:
## ./argparse.sh --x="blah"
## ./argparse.sh --x="blah" --yy="qwert bye"
## ./argparse.sh x="blah" yy="qwert bye"
##----------------------------------------------------------

local _key
local _val
declare -A args
while [[ "$#" > "0" ]]; do
  case "$1" in 
    (*=*)
        _key="${1%%=*}" &&  _key="${_key/--/}" && _val="${1#*=}"
        args[${_key}]="${_val}"
        # (>&2 echo -e "key:val => ${_key}:${_val}")
        ;;
  esac
  shift
done
# (>&2 echo -e "Total args: ${#args[@]}; Options: ${args[@]}")
