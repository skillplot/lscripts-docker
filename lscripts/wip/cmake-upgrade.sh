#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## cmake, ccmake
###----------------------------------------------------------
##
## Upgrade to latest version of cmake
## sudo apt install cmake the installed version was 3.5.1, [Ubuntu 16.04]
#
## References:
## * http://www.cmake.org/download
## * https://askubuntu.com/questions/355565/how-do-i-install-the-latest-version-of-cmake-from-the-command-line/865294
## * https://cmake.org/Wiki/CMake_Useful_Variables
###----------------------------------------------------------


function cmake-upgrade() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  cmake --version

  if [ -z "${_LSD__EXTERNAL_HOME}" ]; then
    local BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${_LSD__EXTERNAL_HOME}"
  fi

  if [ -z "${CMAKE_VER}" ]; then
    local CMAKE_VER="3.14"
    local CMAKE_BUILD="0"
    local CMAKE_REL="${CMAKE_VER}.${CMAKE_BUILD}"
    echo "Unable to get CMAKE_REL version, falling back to default version#: ${CMAKE_REL}"
  fi

  local DIR="cmake-${CMAKE_REL}"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"
  local FILE="${DIR}.tar.gz"

  local URL="https://cmake.org/files/v${CMAKE_VER}/${FILE}"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  # exit -1 #testing
  if [ ! -f ${HOME}/Downloads/${FILE} ]; then
    wget -c ${URL} -P ${HOME}/Downloads
  else
    echo Not downloading as: ${HOME}/Downloads/${FILE} already exists!
  fi

  if [ ! -d ${PROG_DIR} ]; then
    # tar xvfz ${HOME}/Downloads/${FILE} -C ${_LSD__EXTERNAL_HOME} #verbose
    tar xfz ${HOME}/Downloads/${FILE} -C ${_LSD__EXTERNAL_HOME} #silent mode
    echo "Extracting File: ${HOME}/Downloads/${FILE} here: ${PROG_DIR}"
    echo "Extracting...DONE!"
  else
    echo "Extracted Dir already exists: ${PROG_DIR}"
  fi

  ## Install *-dev packages for maxium functionality support with cmake
  sudo -E apt install -y libncurses5-dev # BUILD_CursesDialog:ON, builds: ccmake
  sudo -E apt install -y libjsoncpp-dev #CMAKE_USE_SYSTEM_JSONCPP
  sudo -E apt install -y bzip2 libbz2-dev #CMAKE_USE_SYSTEM_BZIP2, CMAKE_USE_SYSTEM_LIBLZMA
  sudo -E apt install -y libarchive-dev #CMAKE_USE_SYSTEM_LIBARCHIVE
  sudo -E apt install -y librhash-dev	#CMAKE_USE_SYSTEM_LIBRHASH
  #sudo -E apt install -y libuv1-dev #CMAKE_USE_SYSTEM_LIBUV ## Compilation gave error

  cd ${PROG_DIR}
  ./bootstrap
  ccmake .

  # ccmake -D CMAKE_USE_SYSTEM_CURL=ON  \
  #   -D CMAKE_USE_SYSTEM_EXPAT=ON  \
  #   -D CMAKE_USE_SYSTEM_FORM=ON  \
  #   -D CMAKE_USE_SYSTEM_JSONCPP=ON  \
  #   -D CMAKE_USE_SYSTEM_LIBARCHIVE=OFF \
  #   -D CMAKE_USE_SYSTEM_LIBLZMA=ON \
  #   -D CMAKE_USE_SYSTEM_LIBRHASH=OFF \
  #   -D CMAKE_USE_SYSTEM_LIBUV=ON . 

  make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # # The cmake --version command only works after open a new terminal because cmake is installed under /usr/local/bin/ by default, not /usr/bin
  # bash cmake --version
  # ./configure --prefix=/usr/local --qt-gui

  # # https://ubuntuforums.org/showthread.php?t=1764127
  # sudo apt-get install qt4-qtconfig
  # ldd /usr/bin/qtconfig-qt4

  # # qtchooser -print-env
  # # QT_SELECT="qt5"
  # # QTTOOLDIR="/usr/lib/x86_64-linux-gnu/qt5/bin"
  # # QTLIBDIR="/usr/lib/x86_64-linux-gnu"

  ## sudo apt autoremove '.*qt5.*-dev'

}

cmake-upgrade
