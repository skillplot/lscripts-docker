#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts commands convenience utilities
###----------------------------------------------------------
#
## References:
## * https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display
###----------------------------------------------------------


function lsd-prog.ids() { [[ ! -z $1 ]] && (>&2 echo -e $(pgrep -f $1)); }
function lsd-prog.kill() { [[ ! -z $1 ]] && sudo kill -9 $(pgrep -f $1); }
# function lsd-python.kill() { sudo kill -9 $(pgrep -f python); }
function lsd-python.kill() { lsd.prog.kill python; }
## __pycache__ egg-info
function lsd-ls.pycache() { find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'ls -dl "$0"'; }
function lsd-rm.pycache() { find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'rm -rf "$0"'; }
function lsd-ls.egg() { find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'ls -dl "$0"'; }
function lsd-rm.egg() { find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'rm -rf "$0"'; }
##
function lsd-ls() { ls -lrth | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}'; }
## Image utilities
function lsd-image.resize() { for file in *.${1:-'jpg'}; do convert ${file} -resize ${2:-'50'}% $(date -d now +'%d%m%y_%H%M%S')---${file}; done }
#
function lsd-image.pdf() { gm convert *.${1:-'jpg'} $(date -d now +'%d%m%y_%H%M%S').pdf; }
#
## function lsd.junk() { for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ${HOME}/.Trash/; done }
function lsd-date.get() { echo $(date +"%d-%b-%Y, %A"); }
function lsd-system.info() { type inxi &>/dev/null && inxi -Fxzd; }
#
function lsd-util.salt() {
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


function lsd-util.uuid() {
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
