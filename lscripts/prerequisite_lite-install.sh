#!/bin/bash

##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Pre-requisite lite
###----------------------------------------------------------
#
## References:
## * https://www.pyimagesearch.com/2015/08/24/resolved-matplotlib-figures-not-showing-up-or-displaying/
## * https://github.com/tctianchi/pyvenn/issues/3
#
## To be Tested in Integrated way and sequence of installation to be determined
## on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
## currently, tried after `source geos.install.sh` in Ubuntu 18.04 LTS
###----------------------------------------------------------


function prerequisite_lite-install.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source ${LSCRIPTS}/lscripts.config.sh

  sudo apt -y install tcl-dev tk-dev python-tk python3-tk
}

prerequisite_lite-install.main "$@"
