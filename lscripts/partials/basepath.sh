#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------

declare -a _lsd__basepaths=(
  "${_LSD__DOWNLOADS}"
  "${_LSD__EXTERNAL}"
  "${_LSD__SOFTWARES}"
)

local _lsd__basepath
for _lsd__basepath in ${_lsd__basepaths[*]}; do
  ([[ -d "${_lsd__basepath}" ]] || [[ -L "${_lsd__basepath}" && -d "${_lsd__basepath}" ]]) && \
    lsd-mod.log.info "Using BASEPATH: ${_lsd__basepath}" || {
      # lsd-mod.log.info "Using BASEPATH: ${_lsd__basepath}"
      mkdir -p "${_lsd__basepath}" 1>&2
      chown -R $(id -un):$(id -gn) "${_lsd__basepath}"
   } || lsd-mod.log.fail "Error creating in BASEPATH: ${_lsd__basepath}"
done


# ([[ -d "${_LSD__DOWNLOADS}" ]] || [[ -L "${_LSD__DOWNLOADS}" && -d "${_LSD__DOWNLOADS}" ]]) && \
#   lsd-mod.log.info "Using BASEPATH: ${_LSD__DOWNLOADS}" || {
#     # lsd-mod.log.info "Using BASEPATH: ${_LSD__DOWNLOADS}"
#     mkdir -p "${_LSD__DOWNLOADS}" 1>&2
#     chown -R $(id -un):$(id -gn) "${_LSD__DOWNLOADS}"
#  } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__DOWNLOADS}"



# ([[ -d "${_LSD__EXTERNAL}" ]] || [[ -L "${_LSD__EXTERNAL}" && -d "${_LSD__EXTERNAL}" ]]) && \
#   lsd-mod.log.info "Using BASEPATH: ${_LSD__EXTERNAL}" || {
#     # lsd-mod.log.info "Using BASEPATH: ${_LSD__EXTERNAL}"
#     mkdir -p "${_LSD__EXTERNAL}" 1>&2
#     chown -R $(id -un):$(id -gn) "${_LSD__EXTERNAL}"
#  } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__EXTERNAL}"


# ([[ -d "${_LSD__SOFTWARES}" ]] || [[ -L "${_LSD__SOFTWARES}" && -d "${_LSD__SOFTWARES}" ]]) && \
#   lsd-mod.log.info "Using BASEPATH: ${_LSD__SOFTWARES}" || {
#     # lsd-mod.log.info "Using BASEPATH: ${_LSD__SOFTWARES}"
#     mkdir -p "${_LSD__SOFTWARES}" 1>&2
#     chown -R $(id -un):$(id -gn) "${_LSD__SOFTWARES}"
#  } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__SOFTWARES}"
