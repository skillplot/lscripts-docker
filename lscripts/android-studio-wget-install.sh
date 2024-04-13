#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## android-studio
###----------------------------------------------------------
#
## References:
## * https://developer.android.com/studio/index.html
## * https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.21/android-studio-2022.1.1.21-linux.tar.gz
###----------------------------------------------------------

## Todo: refactor into multiple functions
## Todo: CODEHUB TOOLS Directory concept introduced
function android-studio-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh


  if [ -z "${ANDROID_STUDIO_VER}" ]; then
    local ANDROID_STUDIO_VER="2022.1.1.21"
    echo "Unable to get ANDROID_STUDIO_VER version, falling back to default version#: ${ANDROID_STUDIO_VER}"
  fi

  local _prog="android-studio"

  local PROG=${_prog}
  local DIR="${PROG}-${ANDROID_STUDIO_VER}-linux"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"
  local FILE="${DIR}.tar.gz"

  # local URL=https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.21/android-studio-2022.1.1.21-linux.tar.gz
  local URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/${ANDROID_STUDIO_VER}/${FILE}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  local _LSD_CODEHUB_TOOLS_DIR="${__CODEHUB_ROOT__}/tools"

  [[ -d "${PROG_DIR}" ]] && (
    lsd-mod.log.echo "${PROG_DIR}"
    lsd-mod.log.echo "moving ${PROG_DIR} to ${_LSD_CODEHUB_TOOLS_DIR}"
    # mv ${PROG_DIR} ${_LSD_CODEHUB_TOOLS_DIR}.
  )

  ## /codehub/tools/android-studio-2022.1.1.21-linux/android-studio/build.txt
  local ANDROID_BUILD_VER=$(cat ${_LSD_CODEHUB_TOOLS_DIR}/${DIR}/${PROG}/build.txt | cut -d'-' -f2 | cut -d'.' -f1)
  lsd-mod.log.echo "ANDROID_BUILD_VER: ${ANDROID_BUILD_VER}"

  [[ -L ${PROG}-${ANDROID_BUILD_VER} ]] && {
    lsd-mod.log.echo "Creating symlink..."
    cd ${_LSD_CODEHUB_TOOLS_DIR}
    ln -s ${_LSD_CODEHUB_TOOLS_DIR}/${DIR}/${PROG} ${PROG}-${ANDROID_BUILD_VER}
    cd -
  }

  ## Todo: move to configuration function
  sudo update-alternatives --install /usr/local/android-studio android-studio ${_LSD_CODEHUB_TOOLS_DIR}/android-studio-${ANDROID_BUILD_VER} ${ANDROID_BUILD_VER}
  sudo update-alternatives --config ${PROG}
}

android-studio-wget-install.main "$@"
