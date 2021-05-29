#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##__doc__='redis.md'
###----------------------------------------------------------
## redis
## Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker.
###----------------------------------------------------------
#
## References:
## * https://github.com/antirez/redis-io
## * https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
#
## `wget -c http://download.redis.io/redis-stable.tar.gz`
###----------------------------------------------------------


function redis-wget-make-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  local PROG='redis-stable'
  local DIR=${PROG}
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${PROG}"
  local FILE="${PROG}.tar.gz"

  local URL="http://download.redis.io/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  cd ${PROG_DIR}
  make -j${NUMTHREADS}
  make test -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}

  cd ${LSCRIPTS}
}

redis-wget-make-install
