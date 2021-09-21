#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Cuda Stack - cuda, cudnn, nccl, tensorrt
## also provides environment variables for configuring
## CUDA inside docker container
#
## References:
## * https://developer.download.nvidia.com/compute/machine-learning/repos
## * https://developer.download.nvidia.com/compute/cuda/repos
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function cuda-stack-addrepo-ubuntu1404() {
  ## Not supported
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"
  return -1
}


function cuda-stack-addrepo-ubuntu1604() {
  ###----------------------------------------------------------
  ## References:
  ##  - cuda/dist/ubuntu16.04/9.0/base/Dockerfile
  ##  - https://gitlab.com/nvidia/container-images/cuda/-/issues/21
  #
  ## Warning: apt-key output should not be parsed (stdout is not a terminal)
  ## cudasign.pub: FAILED
  ## sha256sum: WARNING: 1 computed checksum did NOT match
  ###----------------------------------------------------------

  # local NVIDIA_REPO_BASEURL="https://developer.download.nvidia.com/compute"
  local __LINUX_DISTRIBUTION_TR="ubuntu1604"
  # local NVIDIA_OS_ARCH="x86_64"
  # local NVIDIA_CUDA_REPO_KEY="7fa2af80.pub"
  # local NVIDIA_GPGKEY_SUM="d1be581509378368edeec8c1eb2958702feedf3bc3d17011adbf24efacce4ab5"
  # local NVIDIA_GPGKEY_FPR="ae09fe4bbd223a84b2ccfce3f60f4b3d7fa2af80"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"

  sudo apt-get -y update

  sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    gnupg2 \
    curl \
    software-properties-common 2>/dev/null

  curl -fsSL ${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY} | sudo apt-key add - &>/dev/null && {
    echo "deb ${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
    echo "deb ${NVIDIA_REPO_BASEURL}/machine-learning/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list

    sudo apt -y update
  } || lsd-mod.log.fail "Check the URL manually: curl -fsSL  ${CUDA_REPO_KEY_URL}"

}


function cuda-stack-addrepo-ubuntu1804() {
  ###----------------------------------------------------------
  ## References:
  ##  - cuda/dist/ubuntu18.04/10.0/base/Dockerfile
  ###----------------------------------------------------------
  sudo apt-get -y update
  # local NVIDIA_REPO_BASEURL="https://developer.download.nvidia.com/compute"
  local __LINUX_DISTRIBUTION_TR="ubuntu1804"
  # local NVIDIA_OS_ARCH="x86_64"
  # local NVIDIA_CUDA_REPO_KEY="7fa2af80.pub"
  local CUDA_REPO_KEY_URL="${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.debug "CUDA_REPO_KEY_URL: ${CUDA_REPO_KEY_URL}"

  sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    curl \
    software-properties-common 2>/dev/null

  curl -fsSL ${CUDA_REPO_KEY_URL} | sudo apt-key add - &>/dev/null && {
    echo "deb ${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
    echo "deb ${NVIDIA_REPO_BASEURL}/machine-learning/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list

    sudo apt -y update
  } || lsd-mod.log.fail "Check the URL manually: curl -fsSL  ${CUDA_REPO_KEY_URL}"
}


function cuda-stack-addrepo-ubuntu2004() {
  ###----------------------------------------------------------
  ## References:
  ##  - cuda/dist/ubuntu18.04/10.0/base/Dockerfile
  ###----------------------------------------------------------
  sudo apt-get -y update
  # local NVIDIA_REPO_BASEURL="https://developer.download.nvidia.com/compute"
  local __LINUX_DISTRIBUTION_TR="ubuntu2004"
  # local NVIDIA_OS_ARCH="x86_64"
  # local NVIDIA_CUDA_REPO_KEY="7fa2af80.pub"
  local CUDA_REPO_KEY_URL="${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH}/${NVIDIA_CUDA_REPO_KEY}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.debug "CUDA_REPO_KEY_URL: ${CUDA_REPO_KEY_URL}"

  sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    curl \
    software-properties-common 2>/dev/null

  curl -fsSL ${CUDA_REPO_KEY_URL} | sudo apt-key add - &>/dev/null && {
    echo "deb ${NVIDIA_REPO_BASEURL}/cuda/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/cuda.list && \
    echo "deb ${NVIDIA_REPO_BASEURL}/machine-learning/repos/${__LINUX_DISTRIBUTION_TR}/${NVIDIA_OS_ARCH} /" | sudo tee /etc/apt/sources.list.d/nvidia-ml.list

    sudo apt -y update
  } || lsd-mod.log.fail "Check the URL manually: curl -fsSL  ${CUDA_REPO_KEY_URL}"
}


function cuda-stack-addrepo() {
  local __LINUX_DISTRIBUTION_TR
  lsd-mod.log.debug "param 1: $1"
  [[ ! -z $1 ]] && __LINUX_DISTRIBUTION_TR=$1 || __LINUX_DISTRIBUTION_TR=${LINUX_DISTRIBUTION_TR}
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"

  cuda-stack-addrepo-${__LINUX_DISTRIBUTION_TR}
   # &>/dev/null || lsd-mod.log.fail "Internal Error: cuda-stack-addrepo-${__LINUX_DISTRIBUTION_TR}"
}


function cuda-stack-uninstall() {
  lsd-mod.nvidia.purge_cuda_stack
}


function __cuda-stack-install() {
    ## For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
    sudo apt-get install -y --no-install-recommends cuda-cudart-${CUDA_REL}

    ## Only available for: cuda-compat-10-0  cuda-compat-10-1  cuda-compat-10-2  cuda-compat-11-0
    [[ ${CUDA_VER} != "9.0" ]] && sudo apt-get install -y --no-install-recommends cuda-compat-${CUDA_REL}

    [[ -L /usr/local/cuda ]] || sudo ln -s cuda-${CUDA_VER} /usr/local/cuda

    ## Required for nvidia-docker v1
    ## Todo: Error on without docker - permission denies; instead to use cuda-10-2.conf??
    sudo echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf &>/dev/null && \
      sudo echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf &>/dev/null

    export PATH=${__PATH}:${PATH}
    export LD_LIBRARY_PATH=${__LD_LIBRARY_PATH_1}

    ## nvidia-container-runtime
    export NVIDIA_VISIBLE_DEVICES=${__NVIDIA_VISIBLE_DEVICES}
    export NVIDIA_DRIVER_CAPABILITIES=${__NVIDIA_DRIVER_CAPABILITIES}
    export NVIDIA_REQUIRE_CUDA=${__NVIDIA_REQUIRE_CUDA}

    ## E: Held packages were changed and -y was used without --allow-change-held-packages.
    ## E: Packages were downgraded and -y was used without --allow-downgrades.
    sudo apt-get install -y --no-install-recommends --allow-change-held-packages \
        cuda-libraries-${CUDA_REL} \
        libnccl2=${NCCL_PKG} && \
      sudo apt-mark hold libnccl2

    ## cublas only available for 9.0 and 10.0
    ([[ ${CUDA_VER} == "9.0" ]] || [[ ${CUDA_VER} == "10.0" ]]) && \
      sudo apt-get install -y --no-install-recommends \
        cuda-cublas-${CUDA_CUBLAS_PKG_VERSION} \
        cuda-cublas-dev-${CUDA_CUBLAS_PKG_VERSION}

    ## Only available for: cuda-nvtx-10-0  cuda-nvtx-10-1  cuda-nvtx-10-2  cuda-nvtx-11-0  cuda-nvtx-9-1   cuda-nvtx-9-2
    [[ ${CUDA_VER} != "9.0" ]] && sudo apt-get install -y --no-install-recommends cuda-nvtx-${CUDA_REL}

    sudo apt-get install -y --no-install-recommends \
        cuda-samples-${CUDA_REL} \

    ## Development
    ## E: Version '11.0.2-1' for 'cuda-nvml-dev-11-0' was not found
    sudo apt-get install -y --no-install-recommends \
        cuda-nvml-dev-${NVML_VERSION} \
        cuda-command-line-tools-${CUDA_PKG_VERSION} \
        cuda-libraries-dev-${CUDA_PKG_VERSION} \
        cuda-minimal-build-${CUDA_PKG_VERSION} \
        libnccl-dev=${NCCL_PKG}

    ## cuda-core is deprecated after 9.0
    [[ ${CUDA_VER} != "9.0" ]] && \
      sudo apt-get install -y --no-install-recommends \
      cuda-compiler-${CUDA_CORE_PKG_VERSION} \
    || sudo apt-get install -y --no-install-recommends cuda-core-${CUDA_CORE_PKG_VERSION}

    export LIBRARY_PATH=${__LIBRARY_PATH}:${LIBRARY_PATH}

    ## CUDNN
    sudo apt-get install -y --no-install-recommends --allow-change-held-packages \
        libcudnn${CUDNN_VER}=${CUDNN_PKG} \
        libcudnn${CUDNN_VER}-dev=${CUDNN_PKG} && \
      sudo apt-mark hold libcudnn${CUDNN_VER}

    ## Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
    ## dynamic linker run-time bindings
    [[ -d "/usr/local/cuda/lib64" ]] && [[ -L /usr/local/cuda/lib64/stubs/libcuda.so.1 ]] && \
      sudo ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 && \
      sudo echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf && \
      sudo ldconfig

    sudo apt-get install -y --no-install-recommends \
      libnvinfer${TENSORRT_VER}=${LIBNVINFER_PKG} \
      libnvinfer-dev=${LIBNVINFER_PKG}

    ## Tensorflow specific configuration
    ## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
    ## Configure the build for our CUDA configuration.
    export CI_BUILD_PYTHON=${__CI_BUILD_PYTHON}
    export LD_LIBRARY_PATH=${__LD_LIBRARY_PATH_2}:${LD_LIBRARY_PATH}
    export TF_NEED_CUDA=${__TF_NEED_CUDA}
    export TF_NEED_TENSORRT=${__TF_NEED_TENSORRT}
    export TF_CUDA_COMPUTE_CAPABILITIES=${__TF_CUDA_COMPUTE_CAPABILITIES}
    export TF_CUDA_VERSION=${__TF_CUDA_VERSION}
    export TF_CUDNN_VERSION=${__TF_CUDNN_VERSION}

    export DEBIAN_FRONTEND=${__DEBIAN_FRONTEND}
    export FORCE_CUDA=${__FORCE_CUDA}
    export TORCH_CUDA_ARCH_LIST=${__TORCH_CUDA_ARCH_LIST}
}


function cuda-stack-config() {
  ## FYI: not required with boozo stack, as it's pre-configured

  [[ -f ${_LSD__BASHRC_FILE} ]] || lsd-mod.log.fail "File does not exits,_LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  local LINE
  local FILE=${_LSD__BASHRC_FILE}
  lsd-mod.log.warn "Modifying file: _LSD__BASHRC_FILE: ${_LSD__BASHRC_FILE}"

  LINE='export CUDA_HOME="/usr/local/cuda"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export PATH="/usr/local/cuda/bin:$PATH"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$CUDA_HOME/lib64"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  source ${FILE}

  lsd-mod.log.info "Checking...CUDA_HOME..."
  lsd-mod.log.echo "CUDA_HOME: ${CUDA_HOME}"
}


function cuda-stack-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  local _default=yes
  local _que
  local _msg
  local _prog

  type nvidia-smi &>/dev/null \
    || lsd-mod.log.fail "Nvidia driver: nvidia-smi is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/nvidia-driver-install.sh"


  declare -a cuda_vers=($(lsd-mod.nvidia.get__cuda_vers))
  local vers="${cuda_vers[@]}";
  vers=$(echo "${vers// / | }")

  [[ ${LSCRIPTS__DEBUG} -eq 0 ]] || {
    (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
    (for ver in "${cuda_vers[@]}"; do (>&2 echo -e "ver => ${ver}"); done)
  }

  : ${1?
    "Usage:
    bash $0 <cudaversion> [ ${vers} ]"
  }

  lsd-mod.fio.find_in_array "$1" "${cuda_vers[@]}" &>/dev/null \
    || lsd-mod.log.fail "Invalid or not supported CUDA version: $1"

  _prog="cuda-stack"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  lsd-mod.fio.yesno_no "${_que}" && \
      lsd-mod.log.echo "Uninstalling..." && \
      ${_prog}-uninstall \
    || lsd-mod.log.echo "${_msg}"


  local BUILD_FOR_CUDA_VER=$1
  lsd-mod.log.info "Using CUDA version: ${BUILD_FOR_CUDA_VER}"

  local CUDACFG_FILEPATH="${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/cuda-cfg-${BUILD_FOR_CUDA_VER}.sh"
  lsd-mod.log.debug "CUDACFG_FILEPATH: ${CUDACFG_FILEPATH}"

  ls -1 ${CUDACFG_FILEPATH} &>/dev/null || lsd-mod.log.fail "config file does not exists: ${CUDACFG_FILEPATH}"
  ## Only for reference, not used here
  ## local AI_PYCUDA_FILE=${LSCRIPTS}/config/${LINUX_DISTRIBUTION}/python.requirements-ai-cuda-${BUILD_FOR_CUDA_VER}.txt
  ## echo "CUDACFG_FILEPATH: ${AI_PYCUDA_FILE}"

  local __CUDA_LOG_FILEPATH="${__LSCRIPTS_LOG_BASEDIR__}/${scriptname%.*}-cuda-${BUILD_FOR_CUDA_VER}-${__TIMESTAMP__}.log"
  source ${CUDACFG_FILEPATH}
  echo -e "###----------------------------------------------------------"
  source ${LSCRIPTS}/cuda-echo.sh 1>${__CUDA_LOG_FILEPATH} 2>&1
  lsd-mod.log.ok "Verify cuda-stack versions: ${__CUDA_LOG_FILEPATH}"
  echo -e "###----------------------------------------------------------"

  lsd-mod.log.debug "OS: ${OS}"
  lsd-mod.log.debug "CUDA_OS_REL: ${CUDA_OS_REL}"
  lsd-mod.log.debug "LINUX_DISTRIBUTION_TR: ${LINUX_DISTRIBUTION_TR}"
  lsd-mod.log.debug "CUDA_VER: ${CUDA_VER}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding ${_prog} repo..."
    ${_prog}-addrepo ${CUDA_OS_REL}
  } || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Installing..."
    __${_prog}-install ${BUILD_FOR_CUDA_VER} && _default=yes
  } || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Configure ${_prog} now"
  _msg="Skipping ${_prog} configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Configuring..."
    ${_prog}-config
  } || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Configure multiple cuda now"
  _msg="Skipping multiple cuda configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Configuring..."
    lsd-mod.nvidia.update_alternatives_cuda
  } || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }

  _que="Verify ${_prog} now"
  _msg="Skipping ${_prog} verification!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Verifying..."
    source "${LSCRIPTS}/${_prog}-verify.sh"
  }  || lsd-mod.log.echo "${_msg}"

}

cuda-stack-install.main "$@"
