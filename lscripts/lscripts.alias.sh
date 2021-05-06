#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Alias for system configurations and convenience utilities
##----------------------------------------------------------
#
## References:
## https://stackoverflow.com/questions/7131670/make-a-bash-alias-that-takes-a-parameter
## https://stackoverflow.com/questions/2013547/assigning-default-values-to-shell-variables-with-a-single-command-in-bash
###----------------------------------------------------------


function __lscripts_alias__() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ##
  alias lt='ls -lrth'
  alias l='ls -lrth'
  alias lpwd='ls -d -1 ${PWD}/*'
  alias lpwdf='ls -d -1 ${PWD}/*.*'
  ##
  ## create--pyenv::source it or it does not work
  alias create--pyenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  ##
  alias get--gpu-info="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_info"
  alias get--cuda_vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers"
  alias get--cuda_vers_avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers_avail"
  alias get--nvidia_driver_avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_avail"
  alias get--gpu-stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__gpu_stats $1"
  ##
  alias select--cuda="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__cuda"
  alias select--gcc="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__gcc"
  alias select--bazel="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__bazel"
  ##
  alias get--ts="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__timestamp"
  alias get--ip="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__ip"
}


__lscripts_alias__
