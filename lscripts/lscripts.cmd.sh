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


function lsd.prog.ids() { [[ ! -z $1 ]] && (>&2 echo -e $(pgrep -f $1)); }
function lsd.prog.kill() { [[ ! -z $1 ]] && sudo kill -9 $(pgrep -f $1); }
# function lsd.python.kill() { sudo kill -9 $(pgrep -f python); }
function lsd.python.kill() { lsd.prog.kill python; }
## __pycache__ egg-info
function lsd.ls.pycache() { find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'ls -dl "$0"'; }
function lsd.rm.pycache() { find ${PWD}/ -iname __pycache__ -type d | xargs -n 1 bash -c 'rm -rf "$0"'; }
function lsd.ls.egg() { find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'ls -dl "$0"'; }
function lsd.rm.egg() { find ${PWD}/ -iname *.egg-info -type d | xargs -n 1 bash -c 'rm -rf "$0"'; }
##
function lsd.ls.mod() { ls -lrth | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));if(k)printf("%0o ",k);print}'; }
## Image utilities
function lsd.image.resize() { for file in *.${1:-'jpg'}; do convert ${file} -resize ${2:-'50'}% $(date -d now +'%d%m%y_%H%M%S')---${file}; done }
#
function lsd.image.pdf() { gm convert *.${1:-'jpg'} $(date -d now +'%d%m%y_%H%M%S').pdf; }
#
## function lsd.junk() { for item in "$@" ; do echo "Trashing: $item" ; mv "$item" ${HOME}/.Trash/; done }
function lsd.date.get() { echo $(date +"%d-%b-%Y, %A"); }
function lsd.system.info() { type inxi &>/dev/null && inxi -Fxzd; }

