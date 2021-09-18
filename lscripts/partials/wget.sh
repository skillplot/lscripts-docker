#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


[[ ! -f "${_LSD__DOWNLOADS}/${FILE}" ]] && (
  wget -c "${URL}"  -P "${_LSD__DOWNLOADS}"
) || (>&2 echo -e "Not downloading as: ${_LSD__DOWNLOADS}/${FILE} already exists!")
