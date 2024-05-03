#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## conda installation
#
## References:
## * https://docs.conda.io/en/latest/miniconda.html#linux-installers
#
###----------------------------------------------------------


function python-miniconda-main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname} with total params: $#"

  source ${LSCRIPTS}/core/argparse.sh "$@"

  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
  bash /tmp/miniconda.sh
}


python-miniconda-main "$@"
