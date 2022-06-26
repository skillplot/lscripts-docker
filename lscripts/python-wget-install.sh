#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Python build from source code
###----------------------------------------------------------
#
## References:
## * https://linuxize.com/post/how-to-install-python-3-8-on-ubuntu-18-04/
###----------------------------------------------------------


function python-wget-tgz-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  if [ -z "${PYTHON_VER}" ]; then
    # local PYTHON_VER="v1.47.0"
    local PYTHON_VER="3.8.0"
    echo "Unable to get PYTHON_VER version, falling back to default version#: ${PYTHON_VER}"
  fi

  local PROG="python"
  local FILE="Python-${PYTHON_VER}.tgz"

  # local URL="https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz"
  local URL="https://www.python.org/ftp/${PROG}/${PYTHON_VER}/${FILE}"
  local PROG_DIR="${_LSD__SOFTWARES}/${PROG}/Python-${PYTHON_VER}"

  source ${LSCRIPTS}/partials/basepath.sh

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  cd ${PROG_DIR}/Python-${PYTHON_VER}
  ## ./configure
  ./configure --enable-optimizations
  make -j ${NUMTHREADS}
  sudo make altinstall

  ## python3.8 --version
}

python-wget-tgz-install "$@"
