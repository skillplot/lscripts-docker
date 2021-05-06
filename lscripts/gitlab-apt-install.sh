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


function gitlab_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="$HOME/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  local filepath="$(mktemp /tmp/gitlab-ce.install-$(date +"%d%m%y_%H%M%S-XXXXXX").sh)"
  echo "filepath: ${filepath}"
  curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh > ${filepath}
  sudo bash ${filepath}
  sudo apt -y install gitlab-ce
}

gitlab_install
