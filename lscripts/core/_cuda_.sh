#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utilility functions for nvidia 'cuda-stack'
## cuda, cudnn, tensorrt is referred as 'cuda-stack'
###----------------------------------------------------------


function lsd-mod.cuda.get__vars() {

  lsd-mod.log.echo "###----------------------------------------------------------"
  lsd-mod.log.echo "System CFG"
  lsd-mod.log.echo "###----------------------------------------------------------"
  lsd-mod.log.echo "NUMTHREADS: ${bgre}${NUMTHREADS}${nocolor}"
  lsd-mod.log.echo "MACHINE_ARCH: ${bgre}${MACHINE_ARCH}${nocolor}"
  lsd-mod.log.echo "USER_ID: ${bgre}${USER_ID}${nocolor}"
  lsd-mod.log.echo "GRP_ID: ${bgre}${GRP_ID}${nocolor}"
  lsd-mod.log.echo "USR: ${bgre}${USR}${nocolor}"
  lsd-mod.log.echo "GRP: ${bgre}${GRP}${nocolor}"
  lsd-mod.log.echo "LOCAL_HOST: ${bgre}${LOCAL_HOST}${nocolor}"
  lsd-mod.log.echo "OSTYPE: ${bgre}${OSTYPE}${nocolor}"
  lsd-mod.log.echo "OS_ARCH: ${bgre}${OS_ARCH}${nocolor}"
  lsd-mod.log.echo "OS_ARCH_BIT: ${bgre}${OS_ARCH_BIT}${nocolor}"
  lsd-mod.log.echo "LINUX_VERSION: ${bgre}${LINUX_VERSION}${nocolor}"
  lsd-mod.log.echo "LINUX_CODE_NAME: ${bgre}${LINUX_CODE_NAME}${nocolor}"
  lsd-mod.log.echo "LINUX_ID: ${bgre}${LINUX_ID}${nocolor}"
  lsd-mod.log.echo "LINUX_DISTRIBUTION: ${bgre}${LINUX_DISTRIBUTION}${nocolor}"
  lsd-mod.log.echo "LINUX_DISTRIBUTION_TR: ${bgre}${LINUX_DISTRIBUTION_TR}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"


  lsd-mod.log.echo "OS: ${bgre}${OS}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_IMAGE_NAME: ${bgre}${NVIDIA_CUDA_IMAGE_NAME}${nocolor}"
  lsd-mod.log.echo "NVIDIA_REPO_BASEURL: ${bgre}${NVIDIA_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_REPO_BASEURL: ${bgre}${NVIDIA_CUDA_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_ML_REPO_BASEURL: ${bgre}${NVIDIA_ML_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_REPO_KEY: ${bgre}${NVIDIA_CUDA_REPO_KEY}${nocolor}"
  lsd-mod.log.echo "NVIDIA_ML_REPO_KEY: ${bgre}${NVIDIA_ML_REPO_KEY}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"


  local CUDA_REPO_KEY_URL="${NVIDIA_CUDA_REPO_BASEURL}/${LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY}"
  local ML_REPO_KEY_URL="${NVIDIA_ML_REPO_BASEURL}/${LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_ML_REPO_KEY}"
  lsd-mod.log.echo "CUDA_REPO_KEY_URL: ${bgre}${CUDA_REPO_KEY_URL}${nocolor}"
  lsd-mod.log.echo "ML_REPO_KEY_URL: ${bgre}${ML_REPO_KEY_URL}${nocolor}"


  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "CUDA_OS_REL: ${bgre}${CUDA_OS_REL}${nocolor}"
  lsd-mod.log.echo "CUDA_VER: ${bgre}${CUDA_VER}${nocolor}"
  lsd-mod.log.echo "CUDA_PKG: ${bgre}${CUDA_PKG}${nocolor}"
  lsd-mod.log.echo "CUDA_REL: ${bgre}${CUDA_REL}${nocolor}"
  lsd-mod.log.echo "CUDA_VERSION: ${bgre}${CUDA_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDA_CORE_PKG_VERSION: ${bgre}${CUDA_CORE_PKG_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDA_PKG_VERSION: ${bgre}${CUDA_PKG_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDA_CORE_PKG_VERSION: ${bgre}${CUDA_CORE_PKG_VERSION}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "NVML_VERSION: ${bgre}${NVML_VERSION}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "cuDNN_VER: ${bgre}${cuDNN_VER}${nocolor}"
  lsd-mod.log.echo "CUDNN_MAJOR_VERSION: ${bgre}${CUDNN_MAJOR_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDNN_VERSION: ${bgre}${CUDNN_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDNN_VERSION: ${bgre}${CUDNN_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDNN_VERSION: ${bgre}${CUDNN_VERSION}${nocolor}"
  lsd-mod.log.echo "CUDNN_PKG: ${bgre}${CUDNN_PKG}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "NCCL_VERSION: ${bgre}${NCCL_VERSION}${nocolor}"
  lsd-mod.log.echo "NCCL_PKG: ${bgre}${NCCL_PKG}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "TENSORRT_VER: ${bgre}${TENSORRT_VER}${nocolor}"
  lsd-mod.log.echo "LIBNVINFER_VER: ${bgre}${LIBNVINFER_VER}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "TF_VER: ${bgre}${TF_VER}${nocolor}"
  lsd-mod.log.echo "TENSORFLOW_VER: ${bgre}${TENSORFLOW_VER}${nocolor}"
  lsd-mod.log.echo "TF_RELEASE: ${bgre}${TF_RELEASE}${nocolor}"
  lsd-mod.log.echo "TF_BAZEL_VER: ${bgre}${TF_BAZEL_VER}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "KERAS_VER: ${bgre}${KERAS_VER}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "PYTORCH_VER: ${bgre}${PYTORCH_VER}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "BAZEL_VER: ${bgre}${BAZEL_VER}${nocolor}"
  lsd-mod.log.echo "BAZEL_URL: ${bgre}${BAZEL_URL}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__OS: ${bgre}${__OS}${nocolor}"
  lsd-mod.log.echo "__NVIDIA_WHICHONE: ${bgre}${__NVIDIA_WHICHONE}${nocolor}"
  lsd-mod.log.echo "__NVIDIA_IMAGE_TAG: ${bgre}${__NVIDIA_IMAGE_TAG}${nocolor}"
  lsd-mod.log.echo "__NVIDIA_BASE_IMAGE: ${bgre}${__NVIDIA_BASE_IMAGE}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "DOCKER_BLD_IMG_TAG: ${bgre}${DOCKER_BLD_IMG_TAG}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__PATH: ${bgre}${__PATH}${nocolor}"
  lsd-mod.log.echo "__LD_LIBRARY_PATH_1: ${bgre}${__LD_LIBRARY_PATH_1}${nocolor}"
  lsd-mod.log.echo "__LD_LIBRARY_PATH_2: ${bgre}${__LD_LIBRARY_PATH_2}${nocolor}"
  lsd-mod.log.echo "__LIBRARY_PATH: ${bgre}${__LIBRARY_PATH}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__NVIDIA_VISIBLE_DEVICES: ${bgre}${__NVIDIA_VISIBLE_DEVICES}${nocolor}"
  lsd-mod.log.echo "__NVIDIA_DRIVER_CAPABILITIES: ${bgre}${__NVIDIA_DRIVER_CAPABILITIES}${nocolor}"
  lsd-mod.log.echo "__NVIDIA_REQUIRE_CUDA: ${bgre}${__NVIDIA_REQUIRE_CUDA}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__CI_BUILD_PYTHON: ${bgre}${__CI_BUILD_PYTHON}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__TF_NEED_CUDA: ${bgre}${__TF_NEED_CUDA}${nocolor}"
  lsd-mod.log.echo "__TF_NEED_TENSORRT: ${bgre}${__TF_NEED_TENSORRT}${nocolor}"
  lsd-mod.log.echo "__TF_CUDA_COMPUTE_CAPABILITIES: ${bgre}${__TF_CUDA_COMPUTE_CAPABILITIES}${nocolor}"
  lsd-mod.log.echo "__TF_CUDA_VERSION: ${bgre}${__TF_CUDA_VERSION}${nocolor}"
  lsd-mod.log.echo "__TF_CUDNN_VERSION: ${bgre}${__TF_CUDNN_VERSION}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__DEBIAN_FRONTEND: ${bgre}${__DEBIAN_FRONTEND}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.log.echo "__FORCE_CUDA: ${bgre}${__FORCE_CUDA}${nocolor}"
  lsd-mod.log.echo "__TORCH_CUDA_ARCH_LIST: ${bgre}${__TORCH_CUDA_ARCH_LIST}${nocolor}"
  lsd-mod.log.echo "__FVCORE_CACHE: ${bgre}${__FVCORE_CACHE}${nocolor}"
  lsd-mod.log.echo "###----------------------------------------------------------"
}


function lsd-mod.cuda.get__cuda_vers() {
  local ver
  declare -a cuda_vers=(`echo $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/config/${LINUX_DISTRIBUTION}/cuda-cfg-[0-9]*.sh | grep -o -P "(\ *[0-9.]*sh)" | sed -r 's/\.sh//'`)
  # (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  # for ver in "${cuda_vers[@]}"; do
  #   (>&2 echo -e "ver => ${ver}")
  # done
  echo "${cuda_vers[@]}"
}


function lsd-mod.cuda.get__cuda_vers_avail() {
  local ver
  declare -a cuda_vers_avail=(`echo $(ls -d /usr/local/cuda-* | cut -d'-' -f2)`)
  # (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  # for ver in "${cuda_vers_avail[@]}"; do
  #   (>&2 echo -e "ver => ${ver}")
  # done
  echo "${cuda_vers_avail[@]}"
}


function lsd-mod.cuda.admin.purge_cuda_stack() {
  ## Todo: prmpt for passphrase for extra level of protection
  local _que="Do you want to purge cuda stack"
  lsd-mod.fio.yes_or_no_loop "${_que}" && {

    lsd-mod.log.warn "purging cuda stack..."

    sudo apt -y --allow-change-held-packages remove 'cuda*' \
      'cudnn*' \
      'libcudnn*' \
      'libnccl*' \
      'libnvinfer*'
       # &>/dev/null
    
    sudo rm -rf /usr/local/cuda \
      /usr/local/cuda* 1>&2
    
    lsd-mod.log.ok "purging cuda stack... completed."
  } || lsd-mod.log.info "Skipping purging cuda stack."
}


function lsd-mod.cuda.admin.purge_nvidia_stack() {
  lsd-mod.log.warn "purging nvidia driver and cuda, cudnn, tensorrt stack..."

  sudo apt -y --allow-change-held-packages remove 'nvidia-*' \
    'nvidia*' 1>&2

  lsd-mod.cuda.admin.purge_cuda_stack
  lsd-mod.log.ok "purging nvidia stack... completed"
}


function lsd-mod.cuda.update_alternatives_cuda() {
  ## cuda multiple version configuration
  ## Alternative to update-alternative options is to create sym link
  ## I preferred update-alternatives option
  ##
  ## Examples:
  # ## Todo: autopick cuda version and their priorities based on what is installed in the /usr/local/cuda-xx.y
  # if [ -d /usr/local/cuda-11.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-11.0 250
  # fi
  # if [ -d /usr/local/cuda-10.2 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.2 300
  # fi
  # if [ -d /usr/local/cuda-10.1 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.1 500
  # fi
  # if [ -d /usr/local/cuda-10.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.0 200
  # fi
  # if [ -d /usr/local/cuda-9.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-9.0 400
  # fi
  # if [ -d /usr/local/cuda-8.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-8.0 50
  # fi

  declare -a cuda_vers=($(lsd-mod.cuda.get__cuda_vers))
  ## Todo: fix error
  # declare -a weights=($(seq 50 50 `echo (( ${#cuda_vers[@]}*100 ))`))
  declare -a weights=($(seq 50 50 500))

  local ver
  local __count=0
  for ver in "${cuda_vers[@]}"; do
    (>&2 echo -e "cuda-${ver}: ${ver} ${weights[${__count}]}")

    if [[ -d /usr/local/cuda-${ver} ]]; then
      sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-${ver} ${weights[${__count}]}
    fi
    ((__count++))
  done

  sudo update-alternatives --config cuda
}


function lsd-mod.cuda.include() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  local scriptname=$(basename ${BASH_SOURCE[0]})

  declare -a cuda_vers=($(lsd-mod.cuda.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
    (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  local __BUILD_FOR_CUDA_VER=${args['cuda']}
  local __LINUX_DISTRIBUTION=${args['os']}
  [[ ! -z ${__BUILD_FOR_CUDA_VER} ]] || __BUILD_FOR_CUDA_VER=${BUILD_FOR_CUDA_VER}

  [[ ! -z ${__LINUX_DISTRIBUTION} ]] || __LINUX_DISTRIBUTION=${LINUX_DISTRIBUTION}

  lsd-mod.log.ok "${scriptname}::__BUILD_FOR_CUDA_VER: ${__BUILD_FOR_CUDA_VER}"
  lsd-mod.log.ok "${scriptname}::__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"

  lsd-mod.fio.find_in_array "${__BUILD_FOR_CUDA_VER}" "${cuda_vers[@]}" &>/dev/null \
    || lsd-mod.log.fail "Invalid or not supported CUDA version: ${__BUILD_FOR_CUDA_VER}"

  lsd-mod.log.info "Using CUDA version: ${__BUILD_FOR_CUDA_VER}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/config/${__LINUX_DISTRIBUTION}/cuda-cfg-${__BUILD_FOR_CUDA_VER}.sh"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  echo "${CUDACFG_FILEPATH}"
}


function lsd-mod.cuda.cuda-config() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/argparse.sh "$@"

  # # [[ "$#" -lt "1" ]] && lsd-mod.log.error "Invalid number of paramerters: minimum required 1 parameter but given: $#"
  # [[ -n "${args['cuda']+1}" ]] || lsd-mod.log.error "Required paramerter missing (--cuda)!"
  # [[ -n "${args['os']+1}" ]] || lsd-mod.log.error "Required paramerter missing (--os)!"
  
  # local scriptname=$(basename ${BASH_SOURCE[0]})
  # lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  local __BUILD_FOR_CUDA_VER=${args['cuda']}
  local __LINUX_DISTRIBUTION=${args['os']}
  [[ ! -z ${__BUILD_FOR_CUDA_VER} ]] || __BUILD_FOR_CUDA_VER=${BUILD_FOR_CUDA_VER}
  [[ ! -z ${__LINUX_DISTRIBUTION} ]] || __LINUX_DISTRIBUTION=${LINUX_DISTRIBUTION}


  local CUDACFG_FILEPATH=$(lsd-mod.cuda.include "${__BUILD_FOR_CUDA_VER}" "${__BUILD_FOR_CUDA_VER}")
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ## Only for reference, not used here
  ## local AI_PYCUDA_FILE=${LSCRIPTS}/config/${__LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${__BUILD_FOR_CUDA_VER.txt
  ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}${nocolor}"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  local __CUDA_LOG_FILEPATH="${__LSCRIPTS_LOG_BASEDIR__}/${scriptname%.*}-cuda-${__BUILD_FOR_CUDA_VER}-${__TIMESTAMP__}.log"
  lsd-mod.log.debug "__CUDA_LOG_FILEPATH: ${__CUDA_LOG_FILEPATH}"

  source ${CUDACFG_FILEPATH}
  lsd-mod.log.echo "###----------------------------------------------------------"
  source ${LSCRIPTS}/core/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  lsd-mod.log.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  cat "${__CUDA_LOG_FILEPATH}"
  lsd-mod.log.echo "###----------------------------------------------------------"

  lsd-mod.cuda.get__vars

  lsd-mod.log.debug "__BUILD_FOR_CUDA_VER: ${__BUILD_FOR_CUDA_VER}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"
  lsd-mod.log.debug "OS: ${OS}"
  lsd-mod.log.debug "CUDA_OS_REL: ${CUDA_OS_REL}"
  lsd-mod.log.debug "CUDA_VER: ${CUDA_VER}"

  # lsd-mod.cuda.get__vars
  echo "${CUDACFG_FILEPATH}"
}


function lsd-mod.cuda.addrepo-key() {
  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  local __LINUX_DISTRIBUTION_TR="${LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.echo "Allowed:: dist: ${bgre}ubuntu1604 ubuntu1804 ubuntu2004  ubuntu2204 ${nocolor}"
  lsd-mod.log.echo "Default:: dist: ${bgre}${__LINUX_DISTRIBUTION_TR}${nocolor}"

  [[ -n "${args['dist']+1}" ]] && __LINUX_DISTRIBUTION_TR=${args['dist']}
  lsd-mod.log.echo "Using:: dist: ${bgre}${__LINUX_DISTRIBUTION_TR}${nocolor}"


  local CUDA_REPO_KEY_URL="${NVIDIA_CUDA_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY}"
  local ML_REPO_KEY_URL="${NVIDIA_ML_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_ML_REPO_KEY}"

  lsd-mod.log.debug "CUDA_REPO_KEY_URL: ${bgre}${CUDA_REPO_KEY_URL}${nocolor}"
  lsd-mod.log.debug "ML_REPO_KEY_URL: ${bgre}${ML_REPO_KEY_URL}${nocolor}"

  local _default="no"
  local _que="Continue"
  local _msg="Skipping CUDA addrepo-key!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding..."

    sudo apt -y update
    ## Install packages to allow apt to use a repository over HTTPS:
    sudo apt -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common 2>/dev/null

    ## Remove keys
    sudo apt-key del ${NVIDIA_CUDA_REPO_KEY}
    sudo apt-key del ${NVIDIA_ML_REPO_KEY}

    curl -fsSL "${CUDA_REPO_KEY_URL}" | sudo apt-key add - &>/dev/null
    curl -fsSL "${ML_REPO_KEY_URL}" | sudo apt-key add - &>/dev/null
    ## Todo:
    ## local CUDA_REPO_KEY_URL
    ## sudo apt-key fingerprint ${CUDA_REPO_KEY_URL}
  }  || lsd-mod.log.echo "${_msg}"
}


function lsd-mod.cuda.addrepo() {
  local __LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${__LSCRIPTS}/argparse.sh "$@"

  local __LINUX_DISTRIBUTION_TR="${LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.echo "Allowed:: dist: ${bgre}ubuntu1604 ubuntu1804 ubuntu2004  ubuntu2204 ${nocolor}"
  lsd-mod.log.echo "Default:: dist: ${bgre}${__LINUX_DISTRIBUTION_TR}${nocolor}"

  [[ -n "${args['dist']+1}" ]] && __LINUX_DISTRIBUTION_TR=${args['dist']}
  lsd-mod.log.echo "Using:: dist: ${bgre}${__LINUX_DISTRIBUTION_TR}${nocolor}"


  local CUDA_REPO_KEY_URL="${NVIDIA_CUDA_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY}"
  local ML_REPO_KEY_URL="${NVIDIA_ML_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_ML_REPO_KEY}"

  lsd-mod.log.debug "CUDA_REPO_KEY_URL: ${bgre}${CUDA_REPO_KEY_URL}${nocolor}"
  lsd-mod.log.debug "ML_REPO_KEY_URL: ${bgre}${ML_REPO_KEY_URL}${nocolor}"

  local _default="no"
  local _que="Continue"
  local _msg="Skipping CUDA addrepo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding..."

    ## add repo key
    sudo apt -y update
    ## Install packages to allow apt to use a repository over HTTPS:
    sudo apt -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common 2>/dev/null

    ## Remove keys
    sudo apt-key del ${NVIDIA_CUDA_REPO_KEY}
    sudo apt-key del ${NVIDIA_ML_REPO_KEY}

    curl -fsSL "${CUDA_REPO_KEY_URL}" | sudo apt-key add - &>/dev/null
    curl -fsSL "${ML_REPO_KEY_URL}" | sudo apt-key add - &>/dev/null


    # echo "deb ${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
    echo "deb ${NVIDIA_CUDA_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
    # echo "deb ${NVIDIA_REPO_BASEURL}/machine-learning/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list
    echo "deb ${NVIDIA_ML_REPO_BASEURL}/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list

    sudo apt -y update
  }  || lsd-mod.log.echo "${_msg}"
}
