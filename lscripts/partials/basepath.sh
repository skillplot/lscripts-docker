#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------

([[ -d "${_LSD__EXTERNAL_HOME}" ]] || [[ -L "${_LSD__EXTERNAL_HOME}" && -d "${_LSD__EXTERNAL_HOME}" ]]) && lsd-mod.log.info "Using BASEPATH: ${_LSD__EXTERNAL_HOME}" || \
  mkdir -p "${_LSD__EXTERNAL_HOME}" 1>&2 || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__EXTERNAL_HOME}"
