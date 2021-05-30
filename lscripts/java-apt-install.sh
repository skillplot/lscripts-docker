#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Java
###----------------------------------------------------------
#
## References
## * https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt
#
## Intall OpenJDK-8 on ubuntu 14.04
## * https://askubuntu.com/questions/464755/how-to-install-openjdk-8-on-14-04-lts
## * https://unix.stackexchange.com/questions/289166/is-the-openjdk-r-ppa-trustworthy-enough-to-install-on-serJAVA_JDK_VER
## * http://column80.com/api.v2.php?a=askubuntu&q=464755
## * https://launchpad.net/~openjdk-r/+archive/ubuntu/ppa
## * http://openjdk.java.net/projects/jdk8/
###----------------------------------------------------------


function java-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${JAVA_JDK_VER}" ]; then
    local JAVA_JDK_VER="8"
    echo "Unable to get JAVA_JDK_VER version, falling back to default version#: ${JAVA_JDK_VER}"
  fi

  # sudo apt -y update
  sudo apt -y install openjdk-${JAVA_JDK_VER}-jdk

  ## JavaFX
  sudo apt -y install openjfx

  ## ant
  sudo apt -y install ant

  ## Java Config
  source ${LSCRIPTS}/java-config.sh
}

java-apt-install.main "$@"
