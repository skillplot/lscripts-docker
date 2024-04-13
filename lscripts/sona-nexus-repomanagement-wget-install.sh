#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Sona Nexus repomanager
###----------------------------------------------------------
#
## References:
## * https://help.sonatype.com/repomanager3/download/download-archives---repository-manager-3
###----------------------------------------------------------


function sona-nexus-repomanagement.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${SONANEXUS_REL}" ]; then
    local SONANEXUS_REL="3"
    echo "Unable to get SONANEXUS_REL version, falling back to default version#: ${SONANEXUS_REL}"
  fi

  local PROG='nexus'
  local DIR=${PROG}-${SONANEXUS_REL}
  local PROG_DIR="${_LSD__SOFTWARES}/${PROG}"
  local FILE="nexus-3.33.1-01-unix.tar.gz"
  local URL="https://download.sonatype.com/nexus/${SONANEXUS_REL}/${FILE}"

  source ${LSCRIPTS}/partials/basepath.sh
  source ${LSCRIPTS}/partials/wget.sh
  source ${LSCRIPTS}/partials/untargz.sh

  # ln -s ${PROG_DIR} ${_LSD__SOFTWARES}/${PROG}

  ## launch the app
  ## ${_LSD__EXTERNAL_HOME}/${DIR}/nexus.app/nexus
}

sona-nexus-repomanagement.main "$@"
