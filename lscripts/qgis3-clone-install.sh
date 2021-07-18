#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## qGIS 3
###----------------------------------------------------------
#
## References:
## * https://github.com/qgis/QGIS
## * https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
## * https://qgis.org/en/site/getinvolved/index.html
## * https://scriptndebug.wordpress.com/2018/02/27/installing-qgis-3-on-ubuntu-16-04/
## * https://gis.stackexchange.com/questions/272545/installing-qgis-3-0-on-ubuntu
#
## Build from source:
## * https://www.lutraconsulting.co.uk/blog/2017/08/06/qgis3d-build/
## * https://qgis.org/en/site/forusers/alldownloads.html#debian-ubuntu
#
## `wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | gpg --import`
## `gpg --fingerprint CAEB3DC3BDF7FB45`
## `sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45`
#
## `sudo apt autoremove qgis`
## `sudo apt --purge remove qgis python-qgis qgis-plugin-grass`
## `sudo apt autoremove`
## `sudo apt update`
## `sudo apt install qgis python-qgis qgis-plugin-grass saga`
#
## Download:
## * https://qgis.org/debian/dists/bionic/main/
#
## Build Instructions
## * https://htmlpreview.github.io/?https://github.com/qgis/QGIS/blob/master/doc/INSTALL.html#toc11
#
## add Ubuntu 18.04 specific repository of QGIS 3
## * https://linuxhint.com/install-qgis3-geospatial-ubuntu/
###----------------------------------------------------------


function qgis3-uninstall() {
  sudo apt -y remove qgis python-qgis qgis-plugin-grass
}


function qgis3-addrepo-key() {
  ## import the GPG key of QGIS 3 
  # sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3
  # wget -O - https://qgis.org/downloads/qgis-2017.gpg.key | sudo gpg --import

  # # verify whether the GPG key was imported correctly
  # gpg --fingerprint CAEB3DC3BDF7FB45
  # # add the GPG key of QGIS 3 to apt package manager:
  # gpg --export --armor CAEB3DC3BDF7FB45 | sudo apt-key add -

  ## https://gis.stackexchange.com/questions/332245/error-adding-qgis-org-repository-public-key-to-apt-keyring/332247  
  ## https://www.qgis.org/en/site/forusers/alldownloads.html

  # ## 2019
  # wget -O - https://qgis.org/downloads/qgis-2019.gpg.key | sudo gpg --import
  # ## verify whether the GPG key was imported correctly
  # gpg --fingerprint 51F523511C7028C3
  # ## add the GPG key of QGIS 3 to apt package manager:
  # gpg --export --armor 51F523511C7028C3 | sudo apt-key add -


  ## 2020
  wget -O - https://qgis.org/downloads/qgis-2020.gpg.key | sudo gpg --import
  gpg --fingerprint F7E06F06199EF2F2
  gpg --export --armor F7E06F06199EF2F2 | sudo apt-key add -
}


function qgis3-addrepo() {
  sudo sh -c 'echo "deb https://qgis.org/debian bionic main" > /etc/apt/sources.list.d/qgis3.list'
}


function qgis3-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="qgis3"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  qgis3-addrepo

  qgis3-addrepo-key

  sudo apt -y update
  ## install QGIS 3
  sudo apt -y install qgis python-qgis qgis-plugin-grass


  ## Setting up qgis-providers (1:3.10.1+28bionic) ...
  # /usr/lib/qgis/crssync: /usr/local/lib/libtiff.so.5: no version information available (required by /usr/lib/libgdal.so.20)
  # /usr/lib/qgis/crssync: /usr/local/lib/libtiff.so.5: no version information available (required by /usr/lib/x86_64-linux-gnu/libpoppler.so.73)
  # /usr/lib/qgis/crssync: /usr/local/lib/libtiff.so.5: no version information available (required by /usr/lib/x86_64-linux-gnu/libgeotiff.so.2)
  # Setting up libqgis-server3.10.1 (1:3.10.1+28bionic) ...




  # source ./lscripts.config.sh

  # if [ -z "$BASEPATH" ]; then
  #   BASEPATH="$HOME/softwares"
  #   echo "Unable to get BASEPATH, using default path#: $BASEPATH"
  # fi

  # source ./numthreads.sh ##NUMTHREADS
  # DIR="QGIS"
  # PROG_DIR="$BASEPATH/$DIR"

  # URL="https://github.com/qgis/$DIR.git"

  # echo "Number of threads will be used: $NUMTHREADS"
  # echo "BASEPATH: $BASEPATH"
  # echo "URL: $URL"
  # echo "PROG_DIR: $PROG_DIR"

  # if [ ! -d $PROG_DIR ]; then
  #   git -C $PROG_DIR || git clone $URL $PROG_DIR
  # else
  #   echo Git clone for $URL exists at: $PROG_DIR
  # fi

  # if [ -d $PROG_DIR/build ]; then
  #   rm -rf $PROG_DIR/build
  # fi

  # mkdir $PROG_DIR/build
  # cd $PROG_DIR/build
  # cmake ..
  # ccmake ..
  # make -j$NUMTHREADS
  # sudo make install -j$NUMTHREADS


  # qgis install following python libs, look into them

  # python3-owslib
  # python3-bs4
  # python3-webencodings
  # python3-html5lib
  # python3-webencodings
  # python3-lxml
  # python3-pyparsing
  # python3-cycler
  # python3-bs4
  # python3-gdal
  # python3-jsonschema
  # python3-psycopg2
  # python3-future
  # python3-ipython-genutils
  # python3-jinja2
  # python3-html5lib
  # python3-sip
  # python3-pyproj
  # python3-traitlets
  # python3-dateutil
  # python3-pygments
  # python3-jupyter-core
  # python3-nbformat
  # python3-owslib
  # python3-pyqt5
  # python3-plotly
  # python3-pyqt5.qtwebkit
  # python3-pyqt5.qtsvg
  # python3-pyqt5.qtsql
  # python3-matplotlib
  # python3-pyqt5.qsci
  # libqgispython3.4.1

  # ##----------------------------------------------------------
  # ### Build Error Log
  # ##----------------------------------------------------------

  # # Could not find GRASS 7
  # # flex not found - aborting

}

qgis3-apt-install.main "$@"
