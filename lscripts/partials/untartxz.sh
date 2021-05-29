#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  (>&2 echo -e "Extracting File: ${_LSD__DOWNLOADS_HOME}/${FILE} here: ${PROG_DIR}")
  tar Jxvf "${_LSD__DOWNLOADS_HOME}/${FILE}" -C "${_LSD__EXTERNAL_HOME}"
  (>&2 echo -e "Extracting...DONE!")
) || (>&2 echo -e "Extracted Dir already exists: ${PROG_DIR}")
