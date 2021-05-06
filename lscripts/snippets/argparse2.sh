#!/bin/bash

###----------------------------------------------------------
## key value parser for shell script for bash shell
###----------------------------------------------------------
#
## References and Credits:
## * http://tldp.org/LDP/abs/html/parameter-substitution.html
## * https://stackoverflow.com/questions/14370133/is-there-a-way-to-create-key-value-pairs-in-bash-script#14371026
## * https://stackoverflow.com/questions/5499472/specify-command-line-arguments-like-name-value-pairs-for-shell-script
#
## @Example:
## ./argparse.sh --x="blah"
## ./argparse.sh --x="blah" --yy="qwert bye"
## ./argparse.sh x="blah" yy="qwert bye"
###----------------------------------------------------------


set -u

: ${1?
  'Usage:
  $0 --<key1>="<val1a> <val1b>" [ --<key2>="<val2a> <val2b>" | --<key3>="<val3>" ]'
}

declare -A args
while [[ "$#" > "0" ]]; do
  case "$1" in 
    (*=*)
        _key="${1%%=*}" &&  _key="${_key/--/}" && _val="${1#*=}"
        args[${_key}]="${_val}"
        (>&2 echo -e "key:val => ${_key}:${_val}")
        ;;
  esac
  shift
done
(>&2 echo -e "Total args: ${#args[@]}; Options: ${args[@]}")

## This additional can check for specific key
[[ -n "${args['path']+1}" ]] && (>&2 echo -e "key: 'path' exists") || (>&2 echo -e "key: 'path' does NOT exists");
