#!/bin/bash

## Copyright (c) 2025 mangalbhaskar. All Rights Reserved.
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

source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_log_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_utils_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_date_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_color_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_typeformats_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_system_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_system_.monitoring.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_fio_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_docs_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_docs_.update.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_python_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_stack_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_dir_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_apt_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_image_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_pdf_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_git_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_nvidia_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_cuda_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_docker_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_mongodb_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_systemd_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_crypto_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_virtualbox_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_github_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_gh_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_perf_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_www_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_hpc_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_gdal_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_huggingface_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/_datasets_.sh
