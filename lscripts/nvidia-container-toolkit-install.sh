#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## nvidia-container-runtime
###----------------------------------------------------------
#
## References:
## * https://github.com/NVIDIA/nvidia-docker/issues/1035
## The recommended solution is to update to docker 19.03 and install nvidia-container-toolkit.
##
## * https://github.com/NVIDIA/nvidia-docker/tree/master
## * https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements
## * https://hub.docker.com/r/nvidia/cuda/
## * https://nvidia.github.io/nvidia-container-runtime/
## * https://nvidia.github.io/nvidia-docker/debian8/nvidia-docker.list
##
## `deb https://nvidia.github.io/libnvidia-container/debian8/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-container-runtime/debian8/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-docker/debian8/$(ARCH) /`
##
## * https://nvidia.github.io/nvidia-docker/ubuntu16.04/nvidia-docker.list
##
## `deb https://nvidia.github.io/libnvidia-container/ubuntu16.04/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-container-runtime/ubuntu16.04/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-docker/ubuntu16.04/$(ARCH) /`
##
## * https://nvidia.github.io/nvidia-docker/ubuntu18.04/nvidia-docker.list
##
## `deb https://nvidia.github.io/libnvidia-container/ubuntu18.04/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-container-runtime/ubuntu18.04/$(ARCH) /`
## `deb https://nvidia.github.io/nvidia-docker/ubuntu18.04/$(ARCH) /`
##
## * https://unrealcontainers.com/docs/concepts/nvidia-docker
## * https://www.pugetsystems.com/labs/hpc/Workstation-Setup-for-Docker-with-the-New-NVIDIA-Container-Toolkit-nvidia-docker2-is-deprecated-1568/
###----------------------------------------------------------


function nvidia-container-toolkit-uninstall() {
  sudo apt -y remove nvidia-container-toolkit
}

function __nvidia-container-toolkit-install() {
  _log_.info "Docker version: 19.03.1 is minimum recommended version for Nvidia container runtime/toolkit for GPU/cuda docker."

  local DOCKER_VERSION
  type ${DOCKER_CMD} &>/dev/null && DOCKER_VERSION=$(${DOCKER_CMD} --version | cut -d',' -f1 | cut -d' ' -f3)
  _log_.debug "DOCKER_VERSION: ${DOCKER_VERSION}"

  ## Todo: check if minimum 19.03 is installed
  sudo apt -y install nvidia-container-toolkit

  sudo systemctl restart docker
}


function nvidia-container-toolkit-addrepo-key() {
  _log_.debug "NVIDIA_DOCKER_KEY_URL: ${NVIDIA_DOCKER_KEY_URL}"
  curl -s -L "${NVIDIA_DOCKER_KEY_URL}" |  sudo apt-key add -
  ## Todo:
  ## local NVIDIA_DOCKER_REPO_KEY
  ## sudo apt-key fingerprint ${NVIDIA_DOCKER_REPO_KEY}
}


function nvidia-container-toolkit-addrepo() {
  ## distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
  ##    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
  ##    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
  ## Install packages to allow apt to use a repository over HTTPS:
  sudo apt -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common

  local __NVIDIA_DOCKER_URL="${NVIDIA_DOCKER_URL}/${LINUX_DISTRIBUTION}/nvidia-docker.list"

  nvidia-container-addrepo-key

  _log_.debug "__NVIDIA_DOCKER_URL: ${__NVIDIA_DOCKER_URL}"
  curl -s -L  ${__NVIDIA_DOCKER_URL} | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
}

function nvidia-container-toolkit-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local _default=no
  local _que
  local _msg
  local _prog

  source "${LSCRIPTS}/docker-ce-verify.sh" &>/dev/null \
   || _log_.fail "Dependency docker-ce is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/docker-ce-install.sh"

  _prog="nvidia-container-toolkit"

  _log_.info "Install ${_prog}..."
  _log_.warn "sudo access is required!"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Uninstalling..." && \
          ${_prog}-uninstall \
    || _log_.echo "${_msg}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Adding ${_prog} repo..." && \
          ${_prog}-addrepo \
    || _log_.echo "${_msg}"

  _que="Add/Update ${_prog} repo Key"
  _msg="Skipping adding/updating ${_prog} repo!"
  _fio_.yesno_${_default} "${_que}" && \
      _log_.echo "Adding/Updating ${_prog} repo key..." && \
          ${_prog}-addrepo-key \
    || _log_.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  _fio_.yesno_${_default} "${_que}" && \
    _log_.echo "Installing..." && \
    __${_prog}-install \
    || _log_.echo "${_msg}"
}

nvidia-container-toolkit-install
