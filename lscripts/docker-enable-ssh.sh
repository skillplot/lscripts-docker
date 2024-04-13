#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## docker enable ssh
###----------------------------------------------------------


function docker-enable-ssh.main() {
  local _SKILL__DUSER="${_SKILL__DUSER}"
  local _SKILL__DUSER="${_SKILL__DUSER}"

  local _SKILL__DUSER_ID="${_SKILL__DUSER_ID}"
  local _SKILL__DUSER_ID="${_SKILL__DUSER_ID}"

  local _SKILL__DUSER_GRP="${_SKILL__DUSER_GRP}"
  local _SKILL__DUSER_GRP="${_SKILL__DUSER_GRP}"

  local _SKILL__DUSER_GRP_ID="${_SKILL__DUSER_GRP_ID}"
  local _SKILL__DUSER_GRP_ID="${_SKILL__DUSER_GRP_ID}"

  local _SKILL__DOCKER_ROOT_BASEDIR="${_SKILL__DOCKER_ROOT_BASEDIR}"

  sudo apt-get update && apt-get install -y --no-install-recommends \
    openssh-server 2>/dev/null

  ## add docker group and user as same as host group and user ids and names
  sudo addgroup --gid "${_SKILL__DUSER_GRP_ID}" "${_SKILL__DUSER_GRP}" && \
      useradd -ms /bin/bash "${_SKILL__DUSER}" --uid "${_SKILL__DUSER_ID}" --gid "${_SKILL__DUSER_GRP_ID}" && \
      /bin/echo "${_SKILL__DUSER}:${_SKILL__DUSER}" | chpasswd && \
      adduser ${_SKILL__DUSER} sudo && \
      /bin/echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
      /bin/echo "%sudo ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user

  sudo mkdir -p "${_SKILL__DOCKER_ROOT_BASEDIR}" \
        "${_SKILL__DOCKER_ROOT_BASEDIR}/installer" \
        "${_SKILL__DOCKER_ROOT_BASEDIR}/logs" \
        "${_SKILL__DOCKER_ROOT_BASEDIR}/config" \
        "/var/run/sshd"

  sudo chown -R ${_SKILL__DUSER}:${_SKILL__DUSER} "${_SKILL__DOCKER_ROOT_BASEDIR}" && \
      sudo chmod -R a+w "${_SKILL__DOCKER_ROOT_BASEDIR}"

  ## disable root login over ssh
  sudo sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
  ## SSH login fix. Otherwise user is kicked off after login
  sudo sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

  echo "export VISIBLE=now" >> /etc/profile
}

docker-enable-ssh.main
