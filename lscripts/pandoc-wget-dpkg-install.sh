#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Pandoc - a universal document converter
###----------------------------------------------------------
#
## References:
## * https://pandoc.org
## * https://github.com/jgm/pandoc
## * https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-1-amd64.deb
###----------------------------------------------------------


function pandoc-wget-dpkg-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  if [ -z "${PANDOC_VER}" ]; then
    local PANDOC_VER="2.11.2"
    echo "Unable to get PANDOC_VER version, falling back to default version#: ${PANDOC_VER}"
  fi

  local PROG='pandoc'
  local FILE="${PROG}-${PANDOC_VER}-1-amd64.deb"

  ## https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-1-amd64.deb
  local URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  sudo dpkg -i "${_LSD__DOWNLOADS_HOME}/${FILE}"

  # tar xvzf "${_LSD__DOWNLOADS_HOME}/${FILE}" --strip-components 1 -C "/usr/local"
}

pandoc-wget-dpkg-install.main "$@"
