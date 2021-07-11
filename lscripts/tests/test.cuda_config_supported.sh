#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## test:: for docker image build support for cuda version
## and linux_distribution supported
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


[[ "${BASH_SOURCE[0]}" != "${0}" ]] && echo "script ${BASH_SOURCE[0]} is being sourced ..." || echo "Script is a subshell"
[[ $0 != "$BASH_SOURCE" ]] && sourced=1 || sourced=0[1]


function test.cuda_config_supported() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  source "${LSCRIPTS}/../docker-ce-verify.sh" &>/dev/null \
    || _log_.fail "Dependency docker-ce is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/../docker-ce-install.sh"

  declare -a cuda_vers=($(_nvidia_.get__cuda_vers))
  local vers="${cuda_vers[@]}"
  vers=$(echo "${vers// / | }")

  local distributions="${CUDA_LINUX_DISTRIBUTIONS[@]}"
  distributions=$(echo "${distributions// / | }")

  # [[ ${_LSCRIPTS__DEBUG_} -eq 0 ]] || {
  #   (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  #   local ver
  #   (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)

  #   local distribution
  #   (>&2 echo -e "Total CUDA_LINUX_DISTRIBUTIONS: ${#CUDA_LINUX_DISTRIBUTIONS[@]}\n CUDA_LINUX_DISTRIBUTIONS: ${CUDA_LINUX_DISTRIBUTIONS[@]}")
  #   (for distribution in "${CUDA_LINUX_DISTRIBUTIONS[@]}"; do (>&2 echo -e "distributions => ${distribution}"); done)
  # }

  local __error_msg="
  Usage:
    bash $0 <cuda_version> <linux_distribution>
    
    Supported values:
    <cuda_version> => [ ${vers} ]
    <linux_distribution> => [ ${distributions} ]

    example:
    bash $0 ${cuda_vers[0]} ${CUDA_LINUX_DISTRIBUTIONS[0]}
  "
  : ${1? "${__error_msg}" } && : ${2? "${__error_msg}"}

  [[ "$#" -ne "2" ]] && _log_.error "Invalid number of paramerters: required 2 given $#\n ${__error_msg}"


  ( _fio_.find_in_array $1 "${cuda_vers[@]}" || _log_.fail "Invalid or unsupported cuda version: $1" ) && \
    ( _fio_.find_in_array $2 "${CUDA_LINUX_DISTRIBUTIONS[@]}" || _log_.fail "Invalid or unsupported linux distribution: $2" ) && \
    _log_.success "<cuda_version> is $1 and <linux_distribution> is $2"

}

test.cuda_config_supported "$@"
