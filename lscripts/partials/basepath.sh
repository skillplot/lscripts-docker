#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------

([[ -d "${BASEPATH}" ]] || [[ -L "${BASEPATH}" && -d "${BASEPATH}" ]]) && _log_.info "Using BASEPATH: ${BASEPATH}" || \
  mkdir -p "${BASEPATH}" 1>&2 || _log_.fail "Error creating in BASEPATH: ${BASEPATH}"
