#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Execute and install lscripts-docker (lsd) toolkit and utilities
###----------------------------------------------------------


function lsd-lscripts.exe.install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  lsd-mod.log.echo "HUSER (ID):HUSER_GRP (ID)::${HUSER}(${HUSER_ID}):${HUSER_GRP}(${HUSER_GRP_ID})"
  lsd-mod.log.echo "AUSER:AUSER_GRP::${AUSER}:${AUSER_GRP}"

  local _default=no
  local _que
  local _msg

  _que="Do you want to create user"
  _msg="Skipping creating user!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating No-login User: ${AUSER} and Group: ${AUSER_GRP}"
    lsd-system.admin.create-nologin-user --user=${AUSER} --group=${AUSER_GRP}
  } || lsd-mod.log.echo "${_msg}"

  lsd-mod.log.warn "sudo access is required!"
  _que="Do you want to create LSD-OS directories"
  _msg="Skipping creating LSD-OS directories!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating LSD-OS directories"
    ## create OS DIRS
    local _lsd__os_root=$(lsd-dir.admin.mkdir-osdirs)
    lsd-mod.log.echo "_lsd__os_root: ${_lsd__os_root}"

    ls -ltr ${_lsd__os_root} 2>/dev/null && {
      ## permission management
      getent group | grep ${AUSER_GRP} &> /dev/null && {
        lsd-mod.log.echo "Changing ${_LSD__OS_ROOT} to Group ownership with groupname (${AUSER_GRP})"
        # sudo chown -R ${AUSER}:${AUSER_GRP} ${_LSD__OS_ROOT}
        find ${_LSD__OS_ROOT} -type d -exec sudo chgrp ${AUSER_GRP} {} +
        find ${_LSD__OS_ROOT} -type d -exec sudo chmod g+s {} +
      }
    }
  } || lsd-mod.log.echo "${_msg}"

  lsd-mod.log.warn "sudo access is required!"
  _que="Do you want to create LSD-Data directories"
  _msg="Skipping creating LSD-Data directories!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Creating LSD-Data directories"
    ## create Data DIRS
    local _lsd__data_root=$(lsd-dir.admin.mkdir-datadirs)
    lsd-mod.log.echo "_lsd__data_root: ${_lsd__data_root}"
    ls -ltr ${_lsd__data_root} 2>/dev/null && {
      ## permission management
      getent group | grep ${AUSER_GRP} &> /dev/null && {
        lsd-mod.log.echo "Changing ${_LSD__DATA_ROOT} to Group ownership with groupname (${AUSER_GRP})"
        find ${_LSD__DATA_ROOT} -type d -exec sudo chgrp ${AUSER_GRP} {} +
        find ${_LSD__DATA_ROOT} -type d -exec sudo chmod g+s {} +
      }
    }
  } || lsd-mod.log.echo "${_msg}"
}


function lsd-lscripts.exe.include.cuda() {
  declare -a cuda_vers=($(lsd-mod.cuda.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
    (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  # : ${1?
  #   "Usage:
  #   bash $0 <cudaversion> [ ${vers} ]"
  # }


  local BUILD_FOR_CUDA_VER=${args['cuda']}
  local __LINUX_DISTRIBUTION=${args['os']}
  [[ ! -z ${__BUILD_FOR_CUDA_VER} ]] || __BUILD_FOR_CUDA_VER=${__BUILD_FOR_CUDA_VER}

  [[ ! -z ${__LINUX_DISTRIBUTION} ]] || __LINUX_DISTRIBUTION=${LINUX_DISTRIBUTION}


  local BUILD_FOR_CUDA_VER=$1
  # [[ ! -z ${BUILD_FOR_CUDA_VER} ]] || lsd-mod.log.error "CUDA version is mandatory: $1"

  local __LINUX_DISTRIBUTION=$2
  # [[ ! -z ${__LINUX_DISTRIBUTION} ]] || __LINUX_DISTRIBUTION=${LINUX_DISTRIBUTION}

  lsd-mod.fio.find_in_array "${BUILD_FOR_CUDA_VER}" "${cuda_vers[@]}" &>/dev/null \
    || lsd-mod.log.fail "Invalid or not supported CUDA version: ${BUILD_FOR_CUDA_VER}"

  lsd-mod.log.info "Using CUDA version: ${BUILD_FOR_CUDA_VER}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/config/${__LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  echo "${CUDACFG_FILEPATH}"
}



function lsd-lscripts.exe.cuda-get__vars() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  source ${LSCRIPTS}/core/argparse.sh "$@"

  # # [[ "$#" -lt "1" ]] && lsd-mod.log.error "Invalid number of paramerters: minimum required 1 parameter but given: $#"
  # [[ -n "${args['cuda']+1}" ]] || lsd-mod.log.error "Required paramerter missing (--cuda)!"
  # [[ -n "${args['os']+1}" ]] || lsd-mod.log.error "Required paramerter missing (--os)!"
  
  # local scriptname=$(basename ${BASH_SOURCE[0]})
  # lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  local __BUILD_FOR_CUDA_VER=${args['cuda']}
  local __LINUX_DISTRIBUTION=${args['os']}
  [[ ! -z ${__BUILD_FOR_CUDA_VER} ]] || __BUILD_FOR_CUDA_VER=${__BUILD_FOR_CUDA_VER}

  [[ ! -z ${__LINUX_DISTRIBUTION} ]] || __LINUX_DISTRIBUTION=${LINUX_DISTRIBUTION}


  local CUDACFG_FILEPATH=$(lsd-lscripts.exe.include.cuda "${__BUILD_FOR_CUDA_VER}" "${__BUILD_FOR_CUDA_VER}")
  local __CUDA_LOG_FILEPATH="${__LSCRIPTS_LOG_BASEDIR__}/${scriptname%.*}-cuda-${__LINUX_DISTRIBUTION}-${__TIMESTAMP__}.log"

  # ## Only for reference, not used here
  # ## local AI_PYCUDA_FILE=${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
  # ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  # source ${CUDACFG_FILEPATH}
  # lsd-mod.log.echo "###----------------------------------------------------------"
  # source ${LSCRIPTS}/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  # lsd-mod.log.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  # lsd-mod.log.echo "###----------------------------------------------------------"
  # lsd-mod.cuda.get__vars
}


function lsd-lscripts.exe.main() {
  ## create OS Alias
  local _lsd__os_alias_sh=$(lsd-dir.admin.mkalias-osdirs)
  # lsd-mod.log.echo "_lsd__os_alias_sh: ${_lsd__os_alias_sh}"
  [[ -f ${_lsd__os_alias_sh} ]] && source "${_lsd__os_alias_sh}"
  ###----------------------------------------------------------
  ## create Data Alias
  local _lsd__data_alias_sh=$(lsd-dir.admin.mkalias-datadirs)
  # lsd-mod.log.echo "_lsd__data_alias_sh: ${_lsd__data_alias_sh}"
  [[ -f ${_lsd__data_alias_sh} ]] && source "${_lsd__data_alias_sh}"
  ###----------------------------------------------------------
}

