#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## auto documentation utility functions
###----------------------------------------------------------


function lsd-mod.docs.update.get__cmds() {
  local _cmd_prefix=$1
  [[ ! -z "${_cmd_prefix}" ]] || _cmd_prefix="lsd"

  # lsd-mod.log.echo "$(id -un) user can run $(lsd-mod.utils.cmds "${_cmd_prefix}" | wc -l) commands on $(hostname)."
  echo $(lsd-mod.utils.cmds "${_cmd_prefix}")
}


function lsd-mod.docs.update.cmds() {
  local current_dir=${PWD}
  local host_dir_name=$(basename ${current_dir})
  local cmds_filepath="${current_dir}/docs/cmds.md"
  local cmds_filepath_post="${current_dir}/docs/_posts/$(lsd-mod.date.get__blog-post)-cmds.md"


  lsd-mod.log.info "cmds_filepath: ${cmds_filepath}"
  touch ${cmds_filepath} &>/dev/null

  ## Todo: check if git root
  [[ -f "${cmds_filepath}" ]] && {
    [[ "${host_dir_name}" == "lscripts-docker" ]] &&  {
cat > "${cmds_filepath}" <<EOF
---
title: All Commands
description: List of all commands for Lscripts Docker
date: $(lsd-mod.date.get__blog)
last_updated: $(lsd-mod.date.get__full)
note: Auto generated file and will be overwritten
---


# All Commands

EOF
      echo "\`\`\`bash" >> "${cmds_filepath}"
      local _cmd
      for _cmd in $(lsd-mod.docs.update.get__cmds); do
        echo -e "${_cmd}"| tee -a "${cmds_filepath}"
      done
      echo "\`\`\`" >> "${cmds_filepath}"
    }
  } || lsd-mod.log.warn "cmds_filepath: ${cmds_filepath} does not exists."
}


function lsd-mod.docs.search.cmds() {
  local _search="$1"
  local _cmds=($(lsd-mod.docs.update.get__cmds))
  local _cmd
  for _cmd in "${_cmds[@]}"; do
    # echo -e "${_cmd}" | grep -inH --color="auto" "${_search}"
    # echo -e "${_cmd}"
    # printf '%s\n' "${_cmd}" | grep -inH --color="auto" "${_search}"
    # [[ "$_cmd" == *"${_search}"* ]] && echo -e "${_cmd//${_search}/"\e[0;31m${_search}\e[0m"}" || :
    [[ "$_cmd" == *"${_search}"* ]] && echo -e "${_cmd//${_search}/"${bred}${_search}${nocolor}"}" || :
  done
}


function lsd-mod.docs.update() {
  lsd-mod.docs.update.cmds
}
