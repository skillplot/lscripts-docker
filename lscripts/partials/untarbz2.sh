#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  (>&2 echo -e "Extracting File: ${_LSD__DOWNLOADS}/${FILE} here: ${PROG_DIR}")
  mkdir -p ${PROG_DIR}
  tar xvfj "${_LSD__DOWNLOADS}/${FILE}" -C "${PROG_DIR}"
  (>&2 echo -e "Extracting...DONE!")
) || (>&2 echo -e "Extracted Dir already exists: ${PROG_DIR}")
