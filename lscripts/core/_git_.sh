#!/bin/bash

## Copyright (c) 2026 mangalbhaskar. All Rights Reserved.
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
      # lsd-mod.log.echo "git -C ${_repo} pull"
      git -C ${_repo} pull
    }
  done
}

function lsd-mod.git.repo-remote-list() {
  declare -a repos=($(ls -d -1 ${PWD}/*))
  local _repo
  for _repo in ${repos[@]};do
    ( [[ -d ${_repo}/.git ]] || [[ -f ${_repo}/.git ]] ) && {
      # lsd-mod.log.echo "Executing remote -v for repo: ${_repo}"
      # lsd-mod.log.echo "git -C ${_repo} remote -v"
      git -C ${_repo} remote -v
    }
  done
}

function lsd-mod.git.repo-geturls() {
  local basepath_dir=${PWD}
  declare -a DIR_ARRAY=($(ls -d ${basepath_dir}/*))

  # local FILE="/tmp/aihub.external.sh"
  local FILE=/tmp/git-repourls-$(date -d now +"%d%m%y_%H%M%S-%N-XXXXXX").sh
  FILE=$(mktemp ${FILE})

  # touch "${FILE}"
  ls -ltr "${FILE}"

  lsd-mod.log.echo "DIR_ARRAY: ${DIR_ARRAY[@]}"
  lsd-mod.log.echo "==========================="

  lsd-mod.log.echo "FILE: ${FILE}"
  lsd-mod.log.echo "==========================="
  for repo in "${DIR_ARRAY[@]}"; do
    cd ${repo}
    local LINE=$(echo "git clone https:"$(git remote -v | grep -i fetch | cut -d':' -f2 | cut -d' ' -f1))
    lsd-mod.log.echo "${LINE}"
    grep -qF "${LINE}" "${FILE}" || echo "${LINE}" >> "${FILE}"
  done

  echo ${FILE}
}


function lsd-mod.git.repo-checkout() {
  local __branch
  [[ -n "${args['branch']+1}" ]] && __branch=${args['branch']}
  [[ ! -z ${__branch} ]] || __branch='develop'

  declare -a repos=($(ls -d -1 ${PWD}/*))
  local _repo
  for _repo in ${repos[@]};do
    ( [[ -d ${_repo}/.git ]] || [[ -f ${_repo}/.git ]] ) && {
      lsd-mod.log.echo "Executing checkout for repo: ${_repo} and branch: ${__branch}"
      lsd-mod.log.echo "git -C ${_repo} checkout ${__branch}"
      git -C ${_repo} checkout ${__branch}
    }
  done
}


function lsd-mod.git.repo-status() {
  declare -a repos=($(ls -d -1 ${PWD}/*))
  local _repo
  for _repo in ${repos[@]};do
    ( [[ -d ${_repo}/.git ]] || [[ -f ${_repo}/.git ]] ) && {
      lsd-mod.log.echo "Executing status for repo: ${_repo}"
      lsd-mod.log.echo "git -C ${_repo} status"
      git -C ${_repo} status
    }
  done
}


function lsd-mod.git.log-date() {
  declare -a files=($(ls -d -1 ${PWD}/*))
  local _file
  for _file in ${files[@]};do
    lsd-mod.log.echo "Executing status for file: ${_file}"
    lsd-mod.log.echo "git log -p --follow ${_file}"
    git log -p --follow ${_file} | head -n 3 | grep 'Date'
    # git log -p --follow vidteq-ipm-1-gatobev.yml | head -n 3 | grep Date
  done
}


function lsd-mod.git.stats-commit() {
  local _since="$1"
  local _before="$2"
  
  ## Check if since and before are provided
  if [ -z "$_since" ] || [ -z "$_before" ]; then
    echo "Error: 'since' and 'before' dates are required."
    return 1
  fi

  declare -a repos=($(ls -d -1 ${PWD}/*))
  local _repo
  for _repo in "${repos[@]}"; do
    ( [[ -d ${_repo}/.git ]] || [[ -f ${_repo}/.git ]] ) && {
      lsd-mod.log.echo "Generating commit stats for repo: ${_repo}"
      git -C "${_repo}" shortlog -s -n --all --no-merges --since="${_since}" --before="${_before}"
    }
  done
}
