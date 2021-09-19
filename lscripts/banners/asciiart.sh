#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------------
#
## References and Credits:
## Ascii-art generated using:
## * https://textkool.com/en/test-ascii-art-generator?text=LSCRIPTS
###----------------------------------------------------------------


## do not set the log level here, use environment variable
[[ ! -z ${LSCRIPTS__BANNER} ]] || LSCRIPTS__BANNER=1
[[ ! -z ${LSCRIPTS__BANNER_TYPE} ]] || LSCRIPTS__BANNER_TYPE="skillplot-1"


function lsd-mod.asciiart.banner.lscripts-1() {

  (>&2 echo -e "
     _       _____  _____ _____  _____ _____ _______ _____ 
    | |     / ____|/ ____|  __ \|_   _|  __ \__   __/ ____|
    | |    | (___ | |    | |__) | | | | |__) | | | | (___  
    | |     \___ \| |    |  _  /  | | |  ___/  | |  \___ \ 
    | |____ ____) | |____| | \ \ _| |_| |      | |  ____) |
    |______|_____/ \_____|_|  \_\_____|_|      |_| |_____/ 
    >>> Skillplot: $(lsd-utils.date.get)

    ")
}


function lsd-mod.asciiart.banner.skillplot-1() {

  (>&2 echo -e "
      _____ _    _ _ _ _____  _       _   
     / ____| |  (_) | |  __ \| |     | |  
    | (___ | | ___| | | |__) | | ___ | |_ 
     \___ \| |/ / | | |  ___/| |/ _ \| __|
     ____) |   <| | | | |    | | (_) | |_ 
    |_____/|_|\_\_|_|_|_|    |_|\___/ \__|.org
    >>> LSCRIPTS: $(lsd-utils.date.get)

    ")
}


function lsd-mod.asciiart.banner.skillplot-2() {
  (>&2 echo -e "
    ░█▀▀░█░█░▀█▀░█░░░█░░░█▀█░█░░░█▀█░▀█▀
    ░▀▀█░█▀▄░░█░░█░░░█░░░█▀▀░█░░░█░█░░█░
    ░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀░░░▀▀▀░▀▀▀░░▀░.org
    >>> LSCRIPTS: $(lsd-utils.date.get)

    ")
}


function lsd-mod.asciiart.banner.skillplot-3() {

  (>&2 echo -e "

       ▄▄▄▄▄   █  █▀ ▄█ █    █    █ ▄▄  █    ████▄    ▄▄▄▄▀ 
      █     ▀▄ █▄█   ██ █    █    █   █ █    █   █ ▀▀▀ █    
    ▄  ▀▀▀▀▄   █▀▄   ██ █    █    █▀▀▀  █    █   █     █    
     ▀▄▄▄▄▀    █  █  ▐█ ███▄ ███▄ █     ███▄ ▀████    █    .org 
                 █    ▐     ▀    ▀ █        ▀        ▀      
                ▀                   ▀                       
    >>> LSCRIPTS: $(lsd-utils.date.get)

    ")
}


function lsd-mod.asciiart.banner.skillplot-4() {

  (>&2 echo -e "
       ▄████████    ▄█   ▄█▄  ▄█   ▄█        ▄█          ▄███████▄  ▄█        ▄██████▄      ███     
      ███    ███   ███ ▄███▀ ███  ███       ███         ███    ███ ███       ███    ███ ▀█████████▄ 
      ███    █▀    ███▐██▀   ███▌ ███       ███         ███    ███ ███       ███    ███    ▀███▀▀██ 
      ███         ▄█████▀    ███▌ ███       ███         ███    ███ ███       ███    ███     ███   ▀ 
    ▀███████████ ▀▀█████▄    ███▌ ███       ███       ▀█████████▀  ███       ███    ███     ███     
             ███   ███▐██▄   ███  ███       ███         ███        ███       ███    ███     ███     
       ▄█    ███   ███ ▀███▄ ███  ███▌    ▄ ███▌    ▄   ███        ███▌    ▄ ███    ███     ███     
     ▄████████▀    ███   ▀█▀ █▀   █████▄▄██ █████▄▄██  ▄████▀      █████▄▄██  ▀██████▀     ▄████▀   .org
                   ▀              ▀         ▀                      ▀                                
    >>> LSCRIPTS: $(lsd-utils.date.get)

    ")
}


function lsd-mod.asciiart.main() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  [[ ${LSCRIPTS__BANNER} -eq 0 ]] || {
    lsd-mod.asciiart.banner.${LSCRIPTS__BANNER_TYPE}
  }
}
