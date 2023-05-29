#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gitlfs
###----------------------------------------------------------
#
## References:
# wget https://github.com/git-lfs/git-lfs/releases/download/v3.2.0/git-lfs-linux-amd64-v3.2.0.tar.gz -P ${HOME}/Downloads
# # https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-amd64-v3.3.0.tar.gz

# cd ${HOME}/Downloads
# tar -xzf git-lfs-linux-amd64-v3.2.0.tar.gz
# cd git-lfs-3.2.0
# sudo bash install.sh

# git lfs install
###----------------------------------------------------------


function gitlfs-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  source ${LSCRIPTS}/core/argparse.sh "$@"

  ## version overriding
  local version=${GITLFS_VER}
  [[ -n "${args['version']+1}" ]] && version=${args['version']}


  GITLFS_VER=${version}

  if [ -z "${GITLFS_VER}" ]; then
    local GITLFS_VER="3.2.1"
    lsd-mod.log.echo "Unable to get GITLFS_VER version, falling back to default version#: ${GITLFS_VER}"
  fi

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    lsd-mod.log.echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  lsd-mod.log.echo "GITLFS_VER: ${GITLFS_VER}"

  local PROG="git-lfs"
  local FILE="git-lfs-linux-amd64-v${GITLFS_VER}.tar.gz"

  # local URL="https://github.com/git-lfs/git-lfs/releases/download/v3.3.0/git-lfs-linux-amd64-v3.3.0.tar.gz"
  local URL="https://github.com/git-lfs/git-lfs/releases/download/v${GITLFS_VER}/${FILE}"
  local PROG_DIR="${_LSD__SOFTWARES}/${PROG}-${GITLFS_VER}-linux"

  source ${LSCRIPTS}/partials/basepath.sh

  lsd-mod.log.echo "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.echo "URL: ${URL}"
  lsd-mod.log.echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  ## Installation
  cd ${PROG_DIR}/git-lfs-${GITLFS_VER}
  sudo bash install.sh
  git lfs install

  cd -
  # # git lfs --version
}

gitlfs-wget-install.main "$@"
