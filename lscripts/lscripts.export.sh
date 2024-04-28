#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts environment variables 
###----------------------------------------------------------


function lsd-mod.lscripts.export() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source "${LSCRIPTS}/auth/export.auth.sh"

  ## respect local authentication if exists; but *.local files will never be inside repos
  [ -f ${LSCRIPTS}/auth/export.auth.local.sh ] && source ${LSCRIPTS}/auth/export.auth.local.sh

  [[ ! -z ${LSCRIPTS__BASENAME} ]] || export LSCRIPTS__BASENAME="lsdhub"
  [[ ! -z ${LSCRIPTS__ROOT} ]] || export LSCRIPTS__ROOT="/boozo-hub"
  ##
  [[ ! -z ${LSCRIPTS__CODEHUB_ROOT} ]] || export LSCRIPTS__CODEHUB_ROOT="/codehub"
  [[ ! -z ${LSCRIPTS__DATAHUB_ROOT} ]] || export LSCRIPTS__DATAHUB_ROOT="/datahub"
  ##
  [[ ! -z ${LSCRIPTS__BANNER} ]] || LSCRIPTS__BANNER=1
  [[ ! -z ${LSCRIPTS__BANNER_TYPE} ]] || LSCRIPTS__BANNER_TYPE="skillplot-1"
  ##
  [[ ! -z ${LSCRIPTS__DEBUG} ]] || LSCRIPTS__DEBUG=1
  [[ ! -z ${LSCRIPTS__LOG_LEVEL} ]] || LSCRIPTS__LOG_LEVEL=8
  ##
  [[ ! -z ${LSCRIPTS__VMHOME} ]] || export LSCRIPTS__VMHOME=""
  [[ ! -z ${LSCRIPTS__PYVENV_PATH} ]] || export LSCRIPTS__PYVENV_PATH=""
  [[ ! -z ${LSCRIPTS__WSGIPYTHONPATH} ]] || export LSCRIPTS__WSGIPYTHONPATH=""
  [[ ! -z ${LSCRIPTS__WSGIPYTHONHOME} ]] || export LSCRIPTS__WSGIPYTHONHOME=""
  [[ ! -z ${LSCRIPTS__ANDROID_HOME} ]] || export LSCRIPTS__ANDROID_HOME=""
  [[ ! -z ${LSCRIPTS__APACHE_HOME} ]] || export LSCRIPTS__APACHE_HOME=""
  [[ ! -z ${LSCRIPTS__WWW_HOME} ]] || export LSCRIPTS__WWW_HOME=""
  [[ ! -z ${LSCRIPTS__DOWNLOADS} ]] || export LSCRIPTS__DOWNLOADS=""
  [[ ! -z ${LSCRIPTS__EXTERNAL_HOME} ]] || export LSCRIPTS__EXTERNAL_HOME=""
}
