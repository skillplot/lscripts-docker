#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gitlab
###----------------------------------------------------------
#
## References:
## * https://about.gitlab.com/install/#ubuntu
## * https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh
## * https://tecadmin.net/install-gitlab-ce-on-ubuntu/
## * https://packagecloud.io/docs
## * https://github.com/gitlabhq/gitlabhq/blob/master/doc/install/installation.md
## * https://gitlab.com/gitlab-org/gitlab/-/tags
## * https://docs.gitlab.com/ee/install/installation.html
###----------------------------------------------------------


function __gitlab-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  local filepath="$(mktemp /tmp/gitlab-ce.install-$(date +"%d%m%y_%H%M%S-XXXXXX").sh)"
  echo "filepath: ${filepath}"
  # curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh > ${filepath}
  curl ${GITLAB_INSTALLER_URL} > ${filepath}
  sudo bash ${filepath}
  sudo apt -y install gitlab-ce
  # sudo apt -y install gitlab-ee
}


function gitlab-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="gitlab"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
      lsd-mod.log.echo "Installing..."
      __${_prog}-install "$@"
  } || lsd-mod.log.echo "${_msg}"
}

gitlab-apt-install.main "$@"
