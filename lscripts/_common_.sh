#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Lscripts common configurations
## NOTE:
## - Do not change the order of scripts being sourced or variable initialized.
###----------------------------------------------------------


###----------------------------------------------------------
## constants
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/config/color.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/config/typeformats.sh

###----------------------------------------------------------
## log constants and then functions
###----------------------------------------------------------
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/utils/_log_.sh
source $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/utils/_fn_.sh
