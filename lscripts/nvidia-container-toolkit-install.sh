#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
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


function nvidia-container-toolkit-addrepo-key() {
  lsd-mod.log.debug "NVIDIA_DOCKER_KEY_URL: ${NVIDIA_DOCKER_KEY_URL}"

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
    software-properties-common 2>/dev/null

  curl -s -L "${NVIDIA_DOCKER_KEY_URL}" |  sudo apt-key add - &>/dev/null
  ## Todo:
  ## local NVIDIA_DOCKER_REPO_KEY
  ## sudo apt-key fingerprint ${NVIDIA_DOCKER_REPO_KEY}
}


function nvidia-container-toolkit-addrepo-ubuntu1404() {
  ## Not tested
  local __LINUX_DISTRIBUTION="ubuntu14.04"
  lsd-mod.log.debug "LINUX_DISTRIBUTION: ${LINUX_DISTRIBUTION}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"

  local __NVIDIA_DOCKER_URL="${NVIDIA_DOCKER_URL}/${__LINUX_DISTRIBUTION}/nvidia-docker.list"

  nvidia-container-toolkit-addrepo-key

  lsd-mod.log.debug "__NVIDIA_DOCKER_URL: ${__NVIDIA_DOCKER_URL}"
  curl -s -L  ${__NVIDIA_DOCKER_URL} | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
  # return -1
}


function nvidia-container-toolkit-addrepo-ubuntu1604() {
  ## Not tested
  local __LINUX_DISTRIBUTION="ubuntu16.04"
  lsd-mod.log.debug "LINUX_DISTRIBUTION: ${LINUX_DISTRIBUTION}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"

  local __NVIDIA_DOCKER_URL="${NVIDIA_DOCKER_URL}/${__LINUX_DISTRIBUTION}/nvidia-docker.list"

  nvidia-container-toolkit-addrepo-key

  lsd-mod.log.debug "__NVIDIA_DOCKER_URL: ${__NVIDIA_DOCKER_URL}"
  curl -s -L  ${__NVIDIA_DOCKER_URL} | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
}


function nvidia-container-toolkit-addrepo-ubuntu1804() {
  ## verified
  local __LINUX_DISTRIBUTION="ubuntu18.04"
  lsd-mod.log.debug "LINUX_DISTRIBUTION: ${LINUX_DISTRIBUTION}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"

  local __NVIDIA_DOCKER_URL="${NVIDIA_DOCKER_URL}/${__LINUX_DISTRIBUTION}/nvidia-docker.list"

  nvidia-container-toolkit-addrepo-key

  lsd-mod.log.debug "__NVIDIA_DOCKER_URL: ${__NVIDIA_DOCKER_URL}"
  curl -s -L  ${__NVIDIA_DOCKER_URL} | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
}


function nvidia-container-toolkit-addrepo-ubuntu2004() {
  ## Overriding because Ubuntu 20.04 still uses repo of Ubuntu 18.04
  ## Because 20.04 LTS still uses 18.04 LTS repo as of 30th-Sep-2021
  local __LINUX_DISTRIBUTION="ubuntu18.04"
  lsd-mod.log.debug "LINUX_DISTRIBUTION: ${LINUX_DISTRIBUTION}"
  lsd-mod.log.debug "__LINUX_DISTRIBUTION: ${__LINUX_DISTRIBUTION}"

  local __NVIDIA_DOCKER_URL="${NVIDIA_DOCKER_URL}/${__LINUX_DISTRIBUTION}/nvidia-docker.list"

  nvidia-container-toolkit-addrepo-key

  lsd-mod.log.debug "__NVIDIA_DOCKER_URL: ${__NVIDIA_DOCKER_URL}"
  curl -s -L  ${__NVIDIA_DOCKER_URL} | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt -y update
}


function nvidia-container-toolkit-addrepo() {
  local __LINUX_DISTRIBUTION_TR
  lsd-mod.log.debug "param 1: $1"
  [[ ! -z $1 ]] && __LINUX_DISTRIBUTION_TR=$1 || __LINUX_DISTRIBUTION_TR=${LINUX_DISTRIBUTION_TR}
  lsd-mod.log.debug "__LINUX_DISTRIBUTION_TR: ${__LINUX_DISTRIBUTION_TR}"

  nvidia-container-toolkit-addrepo-${__LINUX_DISTRIBUTION_TR}
  # &>/dev/null || lsd-mod.log.fail "Internal Error: nvidia-container-toolkit-addrepo-${__LINUX_DISTRIBUTION_TR}"
}


function nvidia-container-toolkit-uninstall() {
  sudo apt -y remove nvidia-container-toolkit
}


function __nvidia-container-toolkit-install() {
  lsd-mod.log.info "Docker version: 19.03.1 is minimum recommended version for Nvidia container runtime/toolkit for GPU/cuda docker."

  local DOCKER_VERSION
  type ${DOCKER_CMD} &>/dev/null && DOCKER_VERSION=$(${DOCKER_CMD} --version | cut -d',' -f1 | cut -d' ' -f3)
  lsd-mod.log.debug "DOCKER_VERSION: ${DOCKER_VERSION}"

  ## Todo: check if minimum 19.03 is installed
  sudo apt -y install nvidia-container-toolkit

  sudo systemctl restart docker
}


function nvidia-container-toolkit-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  local _default=no
  local _que
  local _msg
  local _prog

  source "${LSCRIPTS}/docker-ce-verify.sh" &>/dev/null \
   || lsd-mod.log.fail "Dependency docker-ce is not installed!\n Execute installer:\n\
            source ${LSCRIPTS}/docker-ce-install.sh"

  _prog="nvidia-container-toolkit"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Uninstalling..."
      ${_prog}-uninstall
  } || lsd-mod.log.echo "${_msg}"

  _que="Update ${_prog} repo Key"
  _msg="Skipping adding/updating ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Adding/Updating ${_prog} repo key..."
      ${_prog}-addrepo-key
  } || lsd-mod.log.echo "${_msg}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Adding ${_prog} repo..."
    ${_prog}-addrepo
  } || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Installing..."
    __${_prog}-install
  } || lsd-mod.log.echo "${_msg}"
}

nvidia-container-toolkit-install.main "$@"
