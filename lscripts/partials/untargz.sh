#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  (>&2 echo -e "Extracting File: ${DOWNLOAD_PATH}/${FILE} here: ${PROG_DIR}")
  tar xvfz "${DOWNLOAD_PATH}/${FILE}" -C "${BASEPATH}"
  (>&2 echo -e "Extracting...DONE!")
) || (>&2 echo -e "Extracted Dir already exists: ${PROG_DIR}")
