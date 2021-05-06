#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## create .deb package
###----------------------------------------------------------


function _create-deb-package() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts/lscripts.config.sh

  ## https://blog.packagecloud.io/eng/2016/12/15/howto-build-debian-package-containing-simple-shell-scripts/
  ## --indep flag will tell dh_make that we intend to create a binary that can be shared across all cpu architectures.
  ## --createorig flag will take the current directory (./greetings-0.1) and create an original source archive necessary for building the package. The source archive will be placed in the parent directory (../greetings_0.1.orig.tar.gz).

  # sudo apt -y install dh-make devscripts

  local DEBEMAIL="skillplot@gmail.com"
  local DEBFULLNAME="skillplot"
  # export ${DEBEMAIL} ${DEBFULLNAME}

  local package_name=$(basename ${LSCRIPTS})
  _log_.info "package_name: ${package_name}"

  dh_make --indep --createorig --packagename ${package_name}
  # dh_make --indep --createorig


}

_create-deb-package
