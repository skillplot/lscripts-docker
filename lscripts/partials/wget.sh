#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -f "${_LSD__DOWNLOADS}/${FILE}" ]] && (
  (>&2 echo -e "_LSD__DOWNLOADS: ${_LSD__DOWNLOADS}")
  wget -c "${URL}"  -P "${_LSD__DOWNLOADS}"
) || (>&2 echo -e "Not downloading as: ${_LSD__DOWNLOADS}/${FILE} already exists!")
