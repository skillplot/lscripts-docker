#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -f "${DOWNLOAD_PATH}/${FILE}" ]] && (
  wget -c "${URL}"  -P "${DOWNLOAD_PATH}"
) || (>&2 echo -e "Not downloading as: ${DOWNLOAD_PATH}/${FILE} already exists!")
