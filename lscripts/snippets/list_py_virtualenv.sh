#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## List all the python vistual environment.
###----------------------------------------------------------


function lsv() {
  local gre='\e[0;32m';
  local nocolor='\e[0m'    # text reset
  local biyel='\e[1;93m';

  local pyenv
  declare -a pyenvs=($(lsvirtualenv | tr -d [=]))

  echo -e "${gre}Listing all of the python virtual environments:${nocolor}"
  echo -e "${biyel}Total: ${#pyenvs[@]}${nocolor}"
  for pyenv in ${pyenvs[@]}; do echo -e "${gre}${pyenv}${nocolor}"; done 
}

lsv
