#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ -f "${_LSD__DOWNLOADS}/${FILE}" ]] && (
  (>&2 echo -e "_LSD__DOWNLOADS: ${_LSD__DOWNLOADS}")
  sudo dpkg -i "${_LSD__DOWNLOADS}/${FILE}" 2>/dev/null
) || (>&2 echo -e "Not Insalling .deb: ${_LSD__DOWNLOADS}/${FILE} does not exists!")
