#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## _git_ functions
###----------------------------------------------------------


function lsd-mod.git-pull() {
  find ${_LSD__ROOT} -mindepth 1 -maxdepth 2 -type d -exec bash -c "if [ -d {}/.git ]; then echo {}; git -C {} pull; fi" \;
}


function lsd-mod.git.repo-pull() {
  declare -a repos=($(ls -d -1 $PWD/*))
  local _repo
  for _repo in ${repos[@]};do
    [[ -d ${_repo}/.git ]] && {
      lsd-mod.log.echo "Executing pull for repo: ${_repo}"
      git -C ${_repo} pull
    }
  done
}
