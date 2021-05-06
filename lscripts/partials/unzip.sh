#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  unzip -q "${DOWNLOAD_PATH}/${FILE}" -d "${BASEPATH}"
) || (>&2 echo -e "Extracted Dir already exists: ${PROG_DIR}")
