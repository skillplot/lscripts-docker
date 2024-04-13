#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -d "${PROG_DIR}" ]] && (
  ## git version 1.6+
  # git clone --recursive $URL

  ## git version >= 2.8
  # git clone --recurse-submodules -j8 "${URL}" "${PROG_DIR}"
  git -C "${PROG_DIR}" || git clone "${URL}" "${PROG_DIR}"
) || (>&2 echo -e "Git clone for ${URL} exists at: ${PROG_DIR}")
