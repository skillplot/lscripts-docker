#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## shotcut Video Editor
###----------------------------------------------------------
#
## References:
## * https://shotcut.org/download/
## * https://github.com/mltframework/shotcut/
###----------------------------------------------------------


function shotcut-wget-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  # local SHOTCUT_REL="v18.08"
  # local FILE="shotcut-linux-x86_64-180801.tar.bz2"

  if [ -z "${SHOTCUT_REL}" ]; then
    local SHOTCUT_REL="v19.12.31"
    echo "Unable to get SHOTCUT_REL version, falling back to default version#: ${SHOTCUT_REL}"
  fi

  local PROG='shotcut'
  local DIR=${PROG}-${SHOTCUT_REL}
  local FILE="shotcut-linux-x86_64-191231.txz"
  # local URL=https://github.com/mltframework/shotcut/releases/download/v19.12.31/shotcut-linux-x86_64-191231.txz
  local URL="https://github.com/mltframework/shotcut/releases/download/${SHOTCUT_REL}/${FILE}"

  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untartxz.sh

  ## launch the app
  ## ${_LSD__EXTERNAL_HOME}/${DIR}/Shotcut.app/shotcut
}

shotcut-wget-install.main "$@"
