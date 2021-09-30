#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utilility functions for nvidia 'cuda-stack'
## cuda, cudnn, tensorrt is referred as 'cuda-stack'
###----------------------------------------------------------

set -e

function lsd-mod.cuda.get__cuda_vers() {
  local ver
  declare -a cuda_vers=(`echo $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/../config/${LINUX_DISTRIBUTION}/cuda-cfg-[0-9]*.sh | grep -o -P "(\ *[0-9.]*sh)" | sed -r 's/\.sh//'`)
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


function lsd-mod.cuda.purge_cuda_stack() {
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


function lsd-mod.cuda.get__vars() {
  lsd-mod.log.echo "OS: ${bgre}${OS}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_IMAGE_NAME: ${bgre}${NVIDIA_CUDA_IMAGE_NAME}${nocolor}"
  lsd-mod.log.echo "NVIDIA_REPO_BASEURL: ${bgre}${NVIDIA_REPO_BASEURL}${nocolor}"
  lsd-mod.log.echo "NVIDIA_CUDA_REPO_KEY: ${bgre}${NVIDIA_CUDA_REPO_KEY}${nocolor}"
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
