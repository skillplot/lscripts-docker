#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  unzip -q "${_LSD__DOWNLOADS_HOME}/${FILE}" -d "${_LSD__EXTERNAL_HOME}"
) || (>&2 echo -e "Extracted Dir already exists: ${PROG_DIR}")
