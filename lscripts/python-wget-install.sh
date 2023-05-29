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
## Build logs:
## 3.7.0
###-----------
## Failed to build these modules:
## _ctypes                                                        
## Could not build the ssl module!
## Python requires an OpenSSL 1.0.2 or 1.1 compatible libssl with X509_VERIFY_PARAM_set1_host().
## LibreSSL 2.6.4 and earlier do not provide the necessary APIs, https://github.com/libressl-portable/portable/issues/381
#
## The necessary bits to build these optional modules were not found:
## _bz2                  _curses               _curses_panel      
## _dbm                  _gdbm                 _lzma              
## _sqlite3              readline                                 
## To find the necessary bits, look in setup.py in detect_modules() for the module's name.
#
#
## The following modules found by detect_modules() in setup.py, have been
## built by the Makefile instead, as configured by the Setup files:
## _abc                  atexit                pwd                
## time                                                           
#
#
## Failed to build these modules:
## _ctypes
#
## References:
## * https://stackoverflow.com/questions/53543477/building-python-3-7-1-ssl-module-failed
## * https://devguide.python.org/getting-started/setup-building/
## * https://stackoverflow.com/a/46258340
## * https://github.com/asdf-vm/asdf
## * https://realpython.com/intro-to-pyenv/
#
##
###----------------------------------------------------------
## TODO:
## 1. update alernatives setup
### sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8
### sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7
### update-alternatives --config python3
###----------------------------------------------------------


function python-wget-prerequisites() {
  sudo apt -y update

  ## minimum modules: for SSL and _curses
  ## sudo apt -y install libssl-dev libffi-dev

  ## Additional packages:
  ### this gives error post installation for python: 3.7.0 of these
  ## Install packages to allow apt to use a repository over HTTPS:
  sudo apt -y --no-install-recommends install \
    build-essential \
    gdb \
    lcov \
    pkg-config \
    libbz2-dev \
    libffi-dev \
    libgdbm-dev \
    libgdbm-compat-dev \
    liblzma-dev \
    libncurses5-dev \
    libreadline6-dev \
    libsqlite3-dev \
    libssl-dev \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    zlib1g-dev 2>/dev/null
}


function __python-wget-install() {
  if [ -z "${PYTHON_VER}" ]; then
    # local PYTHON_VER="v1.47.0"
    local PYTHON_VER="3.8.0"
    lsd-mod.log.echo "Unable to get PYTHON_VER version, falling back to default version#: ${PYTHON_VER}"
  fi

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    lsd-mod.log.echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  [[ ! -d "${_LSD__EXTERNAL_HOME}" ]] && mkdir -p "${_LSD__EXTERNAL_HOME}"

  lsd-mod.log.echo "PYTHON_VER: ${PYTHON_VER}"

  local PROG="python"
  local FILE="Python-${PYTHON_VER}.tgz"

  # local URL="https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz"
  local URL="https://www.python.org/ftp/${PROG}/${PYTHON_VER}/${FILE}"
  local PROG_DIR="${_LSD__SOFTWARES}/${PROG}/Python-${PYTHON_VER}"

  source ${LSCRIPTS}/partials/basepath.sh

  lsd-mod.log.echo "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  lsd-mod.log.echo "URL: ${URL}"
  lsd-mod.log.echo "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  [[ -d ${PROG_DIR}/Python-${PYTHON_VER} ]] && {
    lsd-mod.log.echo "Compiling: ${PROG_DIR}/Python-${PYTHON_VER}"

    cd ${PROG_DIR}/Python-${PYTHON_VER}

    make clean
    ## ./configure
    ./configure --enable-optimizations --with-pydebug
    make -j ${NUMTHREADS}
    sudo make altinstall

    local _py
    local pyPath

    _py="${PWD}/python"

    lsd-mod.log.echo "py: ${_py}"

    type ${_py} &>/dev/null && {
      ## this is the fullpath of the input python executable you want to use
      local __pyVer=$(${_py} -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
      pyPath="/usr/local/bin/python${__pyVer}"
    } 2>/dev/null

    lsd-mod.log.echo "Source pyPath: ${_py}"
    lsd-mod.log.echo "Installed at pyPath: ${pyPath}"

    local py
    type ${pyPath} &>/dev/null && {
      py=${pyPath}
      lsd-mod.log.echo "version: $(${py} --version)"

      lsd-mod.log.echo "Checking ssl, _curses modules: $(${py} -c 'import ssl; import _curses; print(ssl.OPENSSL_VERSION); print(_curses.version)')"
    } || lsd-mod.log.echo "Not found pyPath: ${pyPath}"

    cd - &>/dev/null
  } || lsd-mod.log.echo "Directory does not exists: ${PROG_DIR}/Python-${PYTHON_VER}"
}


function python-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  source ${LSCRIPTS}/core/argparse.sh "$@"

  ## version overriding
  local version=${PYTHON_VER}
  [[ -n "${args['version']+1}" ]] && version=${args['version']}

  PYTHON_VER=${version}
  lsd-mod.log.echo "PYTHON_VER: ${PYTHON_VER}"

  # lsd-mod.python.find_vers

  ## keeping the fail check here and not the beginning because want to print the CUDA stack details
  local _default=no
  local _que
  local _msg
  local _prog

  _prog="python-wget"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _default="yes"
  _que="Install prerequisites"
  _msg="Skipping installation of prerequisites!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Installing prerequisites..."
    ${_prog}-prerequisites && _default=yes
  }  || lsd-mod.log.echo "${_msg}"


  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && (
    # set -x
    lsd-mod.log.echo "Installing..."
    __${_prog}-install ${__BUILD_FOR_CUDA_VER} && _default=yes
    # set +x
  ) || {
    lsd-mod.log.echo "${_msg}" && _default=no
  }
}


python-wget-install.main "$@"
