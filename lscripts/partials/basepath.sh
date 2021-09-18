#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------


([[ -d "${_LSD__DOWNLOADS}" ]] || [[ -L "${_LSD__DOWNLOADS}" && -d "${_LSD__DOWNLOADS}" ]]) && \
  lsd-mod.log.info "Using BASEPATH: ${_LSD__DOWNLOADS}" || {
    # lsd-mod.log.info "Using BASEPATH: ${_LSD__DOWNLOADS}"
    mkdir -p "${_LSD__DOWNLOADS}" 1>&2
    chown -R $(id -un):$(id -gn) "${_LSD__DOWNLOADS}"
 } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__DOWNLOADS}"



([[ -d "${_LSD__EXTERNAL}" ]] || [[ -L "${_LSD__EXTERNAL}" && -d "${_LSD__EXTERNAL}" ]]) && \
  lsd-mod.log.info "Using BASEPATH: ${_LSD__EXTERNAL}" || {
    # lsd-mod.log.info "Using BASEPATH: ${_LSD__EXTERNAL}"
    mkdir -p "${_LSD__EXTERNAL}" 1>&2
    chown -R $(id -un):$(id -gn) "${_LSD__EXTERNAL}"
 } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__EXTERNAL}"


([[ -d "${_LSD__SOFTWARES}" ]] || [[ -L "${_LSD__SOFTWARES}" && -d "${_LSD__SOFTWARES}" ]]) && \
  lsd-mod.log.info "Using BASEPATH: ${_LSD__SOFTWARES}" || {
    # lsd-mod.log.info "Using BASEPATH: ${_LSD__SOFTWARES}"
    mkdir -p "${_LSD__SOFTWARES}" 1>&2
    chown -R $(id -un):$(id -gn) "${_LSD__SOFTWARES}"
 } || lsd-mod.log.fail "Error creating in BASEPATH: ${_LSD__SOFTWARES}"
