#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utility functions
###----------------------------------------------------------
#
## References:
## * https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display
###----------------------------------------------------------


###----------------------------------------------------------
## General utilities
###----------------------------------------------------------

function _utils_.pid() {
  [[ ! -z $1 ]] && (>&2 echo -e $(pgrep -f $1));
}


###----------------------------------------------------------
## _utils_.kill Terminating utilities
###----------------------------------------------------------

function _utils_.kill() {
  [[ ! -z $1 ]] && sudo kill -9 $(pgrep -f $1);
}


function _utils_.kill.python() {
  lsd.prog.kill python;
}


# function _utils_.kill.python() {
#   sudo kill -9 $(pgrep -f python);
# }


###----------------------------------------------------------
## _utils_.ls listing utilities
###----------------------------------------------------------


function _utils_.ls() {
  ls -lrth | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}';
}

function _utils_.ls.pycache() {
  ## __pycache__ egg-info
  find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'ls -dl "$0"';
}


function _utils_.ls.egg() {
  find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'ls -dl "$0"';
}


###----------------------------------------------------------
## _utils_.rm removing/deletion/trash utilities
###----------------------------------------------------------

function _utils_.rm.pycache() {
  find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'rm -rf "$0"';
}

function _utils_.rm.egg() {
  find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'rm -rf "$0"';
}

function _utils_.trash() {
  for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ${HOME}/.Trash/; done
}

###----------------------------------------------------------
## _utils_.image Image utilities
###----------------------------------------------------------

function _utils_.image.resize() {
  for file in *.${1:-'jpg'}; do convert ${file} -resize ${2:-'50'}% $(date -d now +'%d%m%y_%H%M%S')---${file}; done
}


function _utils_.image.pdf() {
  gm convert *.${1:-'jpg'} $(date -d now +'%d%m%y_%H%M%S').pdf;
}


###----------------------------------------------------------
## _utils_.date Date utilities
###----------------------------------------------------------

function _utils_.date.get() {
  echo $(date +"%d-%b-%Y, %A");
}


###----------------------------------------------------------
## _utils_.system
###----------------------------------------------------------

function _utils_.system.info() {
  type inxi &>/dev/null && inxi -Fxzd;
}


###----------------------------------------------------------
## _utils_.id Identification utilities
###----------------------------------------------------------

function _utils_.id.salt() {
  ###----------------------------------------------------------
  ## To generate security keys and salts
  ###----------------------------------------------------------
  ## References:
  ## https://gist.github.com/earthgecko/3089509
  ###----------------------------------------------------------
  ## Credit: https://gist.github.com/fjarrett
  ## To generate WordPress security keys and salts for a wp-config.php file:
  ## https://api.wordpress.org/secret-key/1.1/salt/
  ## 64 random printable characters
  ## Excludes: space, double quote, single quote, and backslash
  echo $(cat /dev/urandom | tr -dc [:print:] | tr -d '[:space:]\042\047\134' | fold -w 64 | head -n 1)
  ## jVig,+1&z3]}DT*$pvXPY#!z!^A-;[c0n!c*Ju=fy9`+yOauYAve<#fL]?>B9U;/
}


function _utils_.id.get() {
  echo $(uname -a && date) | md5sum | cut -f1 -d" " | head -c ${1:-33}
}


function _utils_.id.uuid() {
  ###----------------------------------------------------------
  ## generate uuid without `uuid` apt utility package
  ###----------------------------------------------------------
  ## References:
  ## https://gist.github.com/earthgecko/3089509
  ###----------------------------------------------------------

  # local charlen=5
  # echo $(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 32)
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null)
  # echo $(tr -dc '[:alnum:]' '[:lower:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null)
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=32 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=5 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(tr -dc '[:alnum:]' < /dev/urandom  | dd bs=1 count=${charlen} 2>/dev/null | tr '[:upper:]' '[:lower:]')
  # echo $(base64 /dev/urandom | tr -d '/+' | head -c 32 | tr '[:upper:]' '[:lower:]')
  # echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${charlen} | head -n 1)
  # # enerates a 24-char string consisting of any printable ASCII character from ! to ~.
  # # Change 24 to whatever length you require, obviously.
  # echo $(head -c24 < <(tr -dc '\041-\176' < /dev/urandom)()
  # # Slight update to prevent password containing single quotes, making it easier to quote a variable containing the password.
  # echo $(head -c24 < <(tr --delete --complement '\041-\046\048-\176' < /dev/urandom)()


  ## Credit: https://gist.github.com/sergeyklay
  ## Generate UUID-like strings: c8521ea3-0f42-4e36-aba7-6de2d7c20725
  echo $(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
}


function _utils_.id.filename() {
  local dirpath
  _log_.echo "Enter the directory path [ Press Enter for default: /tmp]:"
  read dirpath

  [[ -d "${dirpath}" ]] && dirpath=${dirpath%/} || dirpath="/tmp"
  _log_.echo "Using directory path: ${dirpath}"
  local _filename="${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S')"
  echo ${_filename}
}


function _utils_.id.filename-tmp() {
  local dirpath="/tmp"
  echo "${dirpath}/$(basename "${dirpath}")-$(date -d now +'%d%m%y_%H%M%S').log"
}
