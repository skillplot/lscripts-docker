#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## virtualbox
#
## References:
## https://linuxize.com/post/how-to-install-virtualbox-on-ubuntu-18-04/
## https://linuxize.com/post/how-to-install-vagrant-on-ubuntu-18-04/
## https://www.virtualbox.org/wiki/Documentation
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }



function virtualbox-uninstall() {
  sudo apt -y  remove docker docker-engine docker.io containerd runc
}


function virtualbox-addrepo-key() {

  # ## Add Docker’s official GPG key
  # curl -fsSL "${VIRTUALBOX_REPO_KEY_URL}" | sudo apt-key add -

  # ## Verify that you now have the key with the fingerprint:
  # ## 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
  # ## by searching for the last 8 characters of the fingerprint.
  # sudo apt-key fingerprint ${VIRTUALBOX_REPO_URL}
  # sudo apt-key fingerprint ${VIRTUALBOX_REPO_KEY_URL}


  # wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
  curl -sSL https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -

  # wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
  curl -sSL https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
}


function virtualbox-addrepo() {
  lsd-mod.log.echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"
  sudo apt -y update
  ## Install packages to allow apt to use a repository over HTTPS:
  sudo apt -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common

  # local VIRTUALBOX_REPO_URL="http://download.virtualbox.org/virtualbox/debian"
  lsd-mod.log.debug "VIRTUALBOX_REPO_URL: ${VIRTUALBOX_REPO_URL}"

  ## Todo: arch hardcoding to be parameterized
  ## Todo: give user option to select docker version for installation

  ## Use the following command to set up the stable repository.
  ## You always need the stable repository, even if you want to install
  ## builds from the edge or test repositories as well.
  # sudo add-apt-repository \
  #    "deb [arch=amd64] ${VIRTUALBOX_REPO_URL} \
  #    $(lsb_release -cs) \
  #    stable"

  # sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
  sudo add-apt-repository \
     "deb [arch=amd64] ${VIRTUALBOX_REPO_URL} \
     $(lsb_release -cs) \
     contrib"

  sudo apt -y update

  ## List the versions available in your repo
  apt-cache virtualbox
}


function __virtualbox-install() {
  ##  Install a specific version by its fully qualified package name, which is package name (virtualbox) “=” version string (2nd column), for example, virtualbox=18.03.0~ce-0~ubuntu.
  # sudo apt install virtualbox-6.0
  sudo apt install virtualbox virtualbox-ext-pack

  ## Make sure the version of the Extension Pack matches with the VirtualBox version.
  # wget https://download.virtualbox.org/virtualbox/6.0.0/Oracle_VM_VirtualBox_Extension_Pack-6.0.0.vbox-extpack
}


function virtualbox-configure() {
  ###----------------------------------------------------------
  ## Configuration as non-root
  #
  ## References:
  ###----------------------------------------------------------
  lsd-mod.log.debug "no configuration steps yet"
}


function virtualbox-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  echo "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"

  local _default=no
  local _que
  local _msg
  local _prog

  _prog="virtualbox"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Uninstall previous ${_prog} installation"
  _msg="Skipping ${_prog} uninstall!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Uninstalling..." && \
          ${_prog}-uninstall \
    || lsd-mod.log.echo "${_msg}"


  _que="Add/Update ${_prog} repo Key"
  _msg="Skipping adding/updating ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Adding/Updating ${_prog} repo key..." && \
          ${_prog}-addrepo-key \
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

}

virtualbox-apt-install.main "$@"
