#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Python 2 and 3
###----------------------------------------------------------
#
## References:
##  * https://linuxize.com/post/how-to-install-python-3-7-on-ubuntu-18-04/
##  * https://askubuntu.com/questions/609623/enforce-a-shell-script-to-execute-a-specific-python-version
##    * use update alternative for multiple python2 version or python3 version
##  * https://www.learnopencv.com/installing-deep-learning-frameworks-on-ubuntu-with-cuda-support/
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function python-uninstall() {
  lsd-mod.log.warn "python uninstallion not allowed through this script!"
  return -1
}


function __python-install() {
  lsd-mod.log.info "By default, both python2 and python3 are installed."

  lsd-mod.log.info "Installing python 2 and 3 along with other important packages"

  sudo apt -y update

  sudo apt -y install --no-install-recommends \
    libboost-all-dev \
    doxygen \
    libgflags-dev \
    libgoogle-glog-dev \
    liblmdb-dev \
    libblas-dev \
    libatlas-base-dev \
    libopenblas-dev \
    libgphoto2-dev \
    libeigen3-dev \
    libhdf5-dev 

  ## Sugested when installing above on Ubuntu 18.04
  [[ ${LINUX_VERSION} == "18.04" ]] && {
    sudo apt -y install --no-install-recommends \
    libatlas-doc \
    liblapack-doc \
    libeigen3-doc \
    libmrpt-dev \
    libhdf5-doc \
    python-pip \
    python-scipy
  }


  ## TODO: In ubuntu 24.04 LTS fix
  # E: Package 'python-dev' has no installation candidate
  # E: Package 'python-nose' has no installation candidate
  # E: Unable to locate package python-numpy

  sudo apt -y install --no-install-recommends \
    python-dev \
    python-nose \
    python-numpy

  sudo apt -y install  --no-install-recommends \
    python3-dev \
    python3-pip \
    python3-nose \
    python3-numpy \
    python3-scipy
}


function __python-config() {
  local pyVer=$1
  lsd-mod.log.debug "__python-config::pyVer: ${pyVer}"

  local PYTHON
  local PIP
  local pylink
  local piplink
  PYTHON=python${pyVer}
  PIP=pip${pyVer}

  pylink="/usr/bin/python"
  piplink="/usr/bin/pip"

  [[ -L "${pylink}" ]] && {
    lsd-mod.log.warn "removing existing link...: ${pylink}"
    ls -l ${pylink}
    sudo rm -f ${pylink}

  }

  [[ -L "${piplink}" ]] && {
    lsd-mod.log.warn "removing existing link...: ${piplink}"
    ls -l ${piplink}
    sudo rm -f ${piplink}
  }

  lsd-mod.log.info "re-creating link: ${pylink}"
  sudo ln -s $(which ${PYTHON}) ${pylink} &>/dev/null || lsd-mod.log.error "File exists: ${piplink}"
  ls -l ${pylink} &>/dev/null || lsd-mod.log.error "re-linking ${pylink}"

  lsd-mod.log.info "re-creating link: ${piplink}"
  sudo ln -s $(which ${PIP}) ${piplink} &>/dev/null || lsd-mod.log.error "File exists: ${piplink}"
  ls -l ${piplink} &>/dev/null || lsd-mod.log.error "re-linking ${piplink}"

  ${PYTHON} -c 'import sys; print(sys.version_info)' 1>&2
}


function python-config() {
  python2 -m pip --version &>/dev/null || lsd-mod.log.error "While executing: python2 -m pip --version"
  python3 -m pip --version &>/dev/null || lsd-mod.log.error "While executing: python3 -m pip --version"

  local pyVer
  for pyVer in 2 3; do
    __python-config ${pyVer}
  done
}


function python-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="python"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"

  lsd-mod.log.info "Read regarding pip: https://github.com/pypa/pip/issues/5599"

  _que="Configure ${_prog} now (recommended)"
  _msg="Skipping ${_prog} configuration. This is critical for proper python environment working!"
  lsd-mod.fio.yesno_yes "${_que}" && \
      lsd-mod.log.echo "Configuring..." && \
      ${_prog}-config \
    || lsd-mod.log.echo "${_msg}"
}

python-install.main "$@"
