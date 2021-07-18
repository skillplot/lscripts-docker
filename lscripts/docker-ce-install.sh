#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker-ce installation
#
## References:
## * https://docs.docker.com/install/linux/docker-ce/ubuntu/#prerequisites
## * https://docs.docker.com/install/linux/docker-ce/ubuntu/#set-up-the-repository
## * https://get.docker.com/
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function docker-ce-uninstall() {
  sudo apt -y  remove docker docker-engine docker.io containerd runc
}


function docker-ce-addrepo() {
  sudo apt -y update
  ## Install packages to allow apt to use a repository over HTTPS:
  sudo apt -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

  lsd-mod.log.debug "DOCKER_KEY_URL: ${DOCKER_KEY_URL}"

  ## Add Docker’s official GPG key
  curl -fsSL "${DOCKER_KEY_URL}" | sudo apt-key add -

  ## Verify that you now have the key with the fingerprint:
  ## 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
  ## by searching for the last 8 characters of the fingerprint.
  sudo apt-key fingerprint ${DOCKER_REPO_KEY}

  ## Todo: arch hardcoding to be parameterized
  ## Todo: give user option to select docker version for installation

  ## Use the following command to set up the stable repository.
  ## You always need the stable repository, even if you want to install
  ## builds from the edge or test repositories as well.
  sudo add-apt-repository \
     "deb [arch=amd64] ${DOCKER_REPO_URL} \
     $(lsb_release -cs) \
     stable"

  sudo apt -y update

  ## List the versions available in your repo
  apt-cache madison docker-ce

  lsd-mod.log.info "Docker version: 19.03.1 is minimum recommended version for Nvidia container runtime/toolkit for GPU/cuda docker."
}


function __docker-ce-install() {
  ##  Install a specific version by its fully qualified package name, which is package name (docker-ce) “=” version string (2nd column), for example, docker-ce=18.03.0~ce-0~ubuntu.
  # sudo apt-get install docker-ce=<VERSION>
  #
  ##  installs the highest possible version
  # sudo -E apt -q -y install docker-ce
  #
  sudo apt -y install docker-ce docker-ce-cli containerd.io
  ## OR
  ## Install a specific version using the version string from the second column, for example, 5:18.09.1~3-0~ubuntu-xenial.
  # sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io

  ## Verify that Docker CE is installed correctly by running the hello-world image
  sudo docker run hello-world
}


function docker-ce-configure() {
  ###----------------------------------------------------------
  ## Configuration as non-root
  #
  ## References:
  ## * https://docs.docker.com/install/linux/linux-postinstall/
  ## * https://medium.com/@calypsobronte/installing-docker-in-kali-linux-2018-1-ef3a8ce3648
  ## * https://docs.docker.com/install/linux/docker-ce/debian/
  ###----------------------------------------------------------

  sudo groupadd docker
  # sudo usermod -aG docker ${USER}
  sudo gpasswd -a ${USER} docker
  # newgrp docker

  ## Fix for: Debian/Kali Linux
  sudo chown root:docker /var/run/docker.sock
  sudo setfacl -m user:${USER}:rw /var/run/docker.sock
}


function docker-ce-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"
  
  lsd-mod.log.info "Recommended: DOCKER_VERSION < 19.03.1. This is for providing nvidia/cuda container compatibility"
  ## local _default=$(lsd-mod.fio.get_yesno_default)

  local _prog="docker-ce"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=yes
  local _que
  local _msg

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Uninstalling..." && \
      ${_prog}-uninstall \
    || lsd-mod.log.echo "${_msg}"

  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Adding ${_prog} repo..." && \
      ${_prog}-addrepo \
    || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"

  _que="Configure ${_prog} to run without sudo (recommended)"
  _msg="Skipping ${_prog} configuration!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Configuring..." && \
      ${_prog}-configure \
    || lsd-mod.log.echo "${_msg}"

  _que="Re-boot is essential. Do you want to reboot sytem"
  _msg="Re-boot you system later to complete the installation. Further installation will break is not rebooted."
  lsd-mod.fio.yes_or_no_loop "${_que}" && \
      lsd-mod.log.echo "Rebooting system..." && \
      sudo reboot \
    || lsd-mod.log.echo "${_msg}"

  _que="Verify ${_prog} now"
  _msg="Skipping ${_prog} verification!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Verifying..." && \
      source "${LSCRIPTS}/${_prog}-verify.sh" \
    || lsd-mod.log.echo "${_msg}"
}

docker-ce-install.main "$@"
