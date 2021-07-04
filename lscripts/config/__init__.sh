#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## common configurations
#
## NOTE:
## - Do not change the order of scripts being sourced or variable initialized.
#
##----------------------------------------------------------

###----------------------------------------------------------
## Core configuration
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/color-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/typeformats-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/system-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/basepath-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/versions-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/nvidia-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/python-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/stack-cfg.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/menu-cfg.sh

###----------------------------------------------------------
## Users configuration
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/users-cfg.sh

###----------------------------------------------------------
## MongoDB configuration
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/mongo-cfg.sh

###----------------------------------------------------------
## Docker container configuration - This should be the last script
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/docker-container-cfg.sh
