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


function pandoc-wget-dpkg-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  [[ ! -d "${BASEPATH}" ]] && mkdir -p "${BASEPATH}"

  if [ -z "${PANDOC_VER}" ]; then
    local PANDOC_VER="2.11.2"
    echo "Unable to get PANDOC_VER version, falling back to default version#: ${PANDOC_VER}"
  fi

  local PROG='pandoc'
  local FILE="${PROG}-${PANDOC_VER}-1-amd64.deb"

  ## https://github.com/jgm/pandoc/releases/download/2.11.2/pandoc-2.11.2-1-amd64.deb
  local URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh

  sudo dpkg -i "${DOWNLOAD_PATH}/${FILE}"

  # tar xvzf "${DOWNLOAD_PATH}/${FILE}" --strip-components 1 -C "/usr/local"
}

pandoc-wget-dpkg-install
