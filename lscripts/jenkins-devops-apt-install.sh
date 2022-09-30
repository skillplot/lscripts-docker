#!/bin/bash

## Copyright (c) 2022 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## jenkins - devops
###----------------------------------------------------------
#
## References:
## * https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04
###----------------------------------------------------------


function jenkins-uninstall() {
  echo "todo"
}

function jenkins-config() {
  ## Todo: work in progess

  ## Starting Jenkins
  jenkins --httpPort=9090
  sudo systemctl start jenkins
  sudo systemctl status jenkins

  # ## Opening the Firewall
  # sudo ufw allow 8080
  # sudo ufw status
}


function jenkins-addrepo-key() {
  lsd-mod.log.debug "JENKINS_REPO_KEY_URL: ${JENKINS_REPO_KEY_URL}"

  sudo apt -y update
  ## Install packages to allow apt to use a repository over HTTPS:
  sudo apt -y --no-install-recommends install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common 2>/dev/null

  ## pre-requisite
  # sudo apt -y --no-install-recommends install openjdk-11-jdk

  # wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  # sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

  # sudo apt-key del ${JENKINS_REPO_KEY_URL}

  # wget -q -O - ${JENKINS_REPO_KEY_URL} | sudo apt-key add -
  curl -fsSL "${JENKINS_REPO_KEY_URL}" | sudo apt-key add - &>/dev/null
}

function jenkins-addrepo() {
  lsd-mod.log.debug "LINUX_DISTRIBUTION: ${LINUX_DISTRIBUTION}"

  jenkins-addrepo-key

  # sudo sh -c 'echo deb ${JENIKS_REPO_BASEURL} binary/ > /etc/apt/sources.list.d/jenkins.list'
  echo "deb ${JENIKS_REPO_BASEURL} binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
  sudo apt -y update
}

function __jenkins-install() {
  sudo apt -y install jenkins
}


function jenkins-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  ## keeping the fail check here and not the beginning because want to print the CUDA stack details
  local _default=no
  local _que
  local _msg
  local _prog
  ## Installing Jenkins

  _prog="jenkins"

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
    ${_prog}-addrepo "${__LINUX_DISTRIBUTION_TR}"
  } || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x
    lsd-mod.log.echo "Installing..."
    __${_prog}-install && _default=yes
    # set +x
  ) || {
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
}

jenkins-install.main "$@"
