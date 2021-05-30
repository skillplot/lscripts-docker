#!/bin/bash

##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Java Config
###----------------------------------------------------------


function java-config.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local FILE
  local LINE
  if [ -z "${BASHRC_FILE}" ]; then
    FILE=${HOME}/.bashrc
  else
    FILE=${BASHRC_FILE}
  fi

  if [ -z "${JAVA_JDK_VER}" ]; then
    JAVA_JDK_VER="8"
  fi

  LINE='export JAVA_HOME="/usr/lib/jvm/java-'${JAVA_JDK_VER}'-openjdk-amd64"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export PATH="$PATH:/usr/lib/jvm/java-'${JAVA_JDK_VER}'-openjdk-amd64/bin"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  LINE='export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/jvm/java-'${JAVA_JDK_VER}'-openjdk-amd64/jre/lib/amd64/server"'
  grep -qF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

  source ${FILE}
  echo "Checking...JNI..."
  ls ${JAVA_HOME}/include/jni.h

  #update-java-alternatives -l
  sudo update-alternatives --config java

  #export TOMCAT_HOME=/usr/share/tomcat5
}

java-config.main "$@"
