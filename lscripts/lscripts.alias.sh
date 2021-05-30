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


function lscripts.alias.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  ##
  alias lt='ls -lrth'
  alias l='ls -lrth'
  alias lpwd='ls -d -1 ${PWD}/*'
  alias lpwdf='ls -d -1 ${PWD}/*.*'
  ##
  alias lsd.python.create.virtualenv="source ${LSCRIPTS}/python-virtualenvwrapper-install.sh"
  ##
  alias lsd.nvidia.gpu.info="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_info"
  alias lsd.nvidia.gpu.stats="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__gpu_stats $1"
  alias lsd.nvidia.cuda.vers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers"
  alias lsd.nvidia.cuda.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__cuda_vers_avail"
  alias lsd.nvidia.driver.avail="bash ${LSCRIPTS}/exec_cmd.sh cmd=_nvidia_.get__driver_avail"
  ##
  alias lsd.select.cuda="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__cuda"
  alias lsd.select.gcc="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__gcc"
  alias lsd.select.bazel="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.select__bazel"
  ##
  alias lsd.date.timestamp="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp"
  alias lsd.date.timestamp.millisec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_millisec"
  alias lsd.date.timestamp.microsec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_microsec"
  alias lsd.date.timestamp.nanosec="bash ${LSCRIPTS}/exec_cmd.sh cmd=_date_.get__timestamp_nanosec"
  ##
  alias lsd.system.cpu.cores="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__cpu_cores"
  alias lsd.system.cpu.threads="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__numthreads"
  alias lsd.system.ip="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__ip"
  alias lsd.system.df.json="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.df_json"
  alias lsd.system.osinfo="bash ${LSCRIPTS}/exec_cmd.sh cmd=_system_.get__osinfo"
  ##
  alias lsd.docker.osvers="bash ${LSCRIPTS}/exec_cmd.sh cmd=_docker_.get__os_vers_avail"
  ##
  alias lsd-stack.list="bash ${LSCRIPTS}/exec_cmd.sh cmd=_fio_.print.stack.list $@"
}


lscripts.alias.main "$@"
