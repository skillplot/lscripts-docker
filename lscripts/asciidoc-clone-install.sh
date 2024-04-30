#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## AsciiDoc
#
## References
## https://github.com/asciidoc/asciidoc-py3
## https://asciidoc.org/INSTALL.html
## https://asciidoc.org/plugins.html
##----------------------------------------------------------


function asciidoc-uninstall() {
  sudo apt -y remove qgis python-qgis qgis-plugin-grass
}


function asciidoc-clone() {
  lsd-mod.log.info "LINUX_CODE_NAME: ${LINUX_CODE_NAME}"
  # sudo sh -c 'echo "deb https://qgis.org/debian bionic main" > /etc/apt/sources.list.d/asciidoc.list'
  sudo sh -c "echo \"deb https://qgis.org/debian ${LINUX_CODE_NAME} main\" > /etc/apt/sources.list.d/asciidoc.list"
  # cat /etc/apt/sources.list.d/asciidoc.list
}


function asciidoc_extensions() {
  export GEM_HOME=${HOME}/.ruby
  export PATH="$PATH:${HOME}/.ruby/bin"

  gem install asciidoctor
  # gem install asciidoctor --pre
  ## https://github.com/asciidoctor/asciidoctor-pdf
  gem install asciidoctor-pdf
  gem which asciidoctor-pdf
  command -v asciidoctor-pdf
  ## Install a Syntax Highlighter (optional)
  gem install pygments.rb

  ## When you install a new version of the gem using gem install, you end up with multiple versions installed. Use the following command to remove the old versions:
  gem cleanup asciidoctor
}


function __asciidoc-install() {
  sudo apt -y install asciidoc

  if [ -z "${BASEPATH}" ]; then
   local BASEPATH="$HOME/softwares"
   lsd-mod.log.info "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${SIMPLE_WEB_SERVER_VER}" ]; then
   local SIMPLE_WEB_SERVER_VER="v3.0.2"
   lsd-mod.log.info "Unable to get SIMPLE_WEB_SERVER_VER version, falling back to default version#: ${SIMPLE_WEB_SERVER_VER}"
  fi

  local PROG="asciidoc-py3"
  local DIR="${PROG}"
  local PROG_DIR="${BASEPATH}/${PROG}"
  ## https://github.com/asciidoc/asciidoc-py3.git
  local URL="https://github.com/asciidoc/${PROG}.git"

  lsd-mod.log.info "Number of threads will be used: ${NUMTHREADS}"
  lsd-mod.log.info "BASEPATH: ${BASEPATH}"
  lsd-mod.log.info "URL: ${URL}"
  lsd-mod.log.info "PROG_DIR: ${PROG_DIR}"

  source ${LSCRIPTS}/partials/gitclone.sh

  cd ${PROG_DIR}
  git pull
  git checkout ${ASCIIDOC_REL}

  [[ -d ${PROG_DIR}/build ]] && rm -rf ${PROG_DIR}/build

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  autoconf
  ./configure

  make -j${NUMTHREADS}
  sudo make docs

  sudo make install -j${NUMTHREADS}

  ## Testing your installation
  make test

  # ## to uninstall
  # # sudo make uninstall

  # cd ${LSCRIPTS}


 ## Install `sudo apt install asciidoc` to fix all the errors
 ## 
 # a2x: executing: "xmllint" --nonet --noout --valid "/codehub/external/asciidoc-py3/doc/asciidoc.1.xml"

 # /bin/sh: 1: xmllint: not found

 # a2x: ERROR: "xmllint" --nonet --noout --valid "/codehub/external/asciidoc-py3/doc/asciidoc.1.xml" returned non-zero exit status 127

 # sudo apt install libxml2-utils

 # a2x: executing: "xmllint" --nonet --noout --valid "/codehub/external/asciidoc-py3/doc/asciidoc.1.xml"

 # I/O error : Attempt to load network entity http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd
 # /codehub/external/asciidoc-py3/doc/asciidoc.1.xml:2: warning: failed to load external entity "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
 # D DocBook XML V4.5//EN" "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd"
 #                                                                                ^
 # /codehub/external/asciidoc-py3/doc/asciidoc.1.xml:5: validity error : Validation failed: no DTD found !
 # <refentry lang="en">
 #                    ^

 # a2x: ERROR: "xmllint" --nonet --noout --valid "/codehub/external/asciidoc-py3/doc/asciidoc.1.xml" returned non-zero exit status 4

 # https://github.com/chjj/compton/issues/86
 # http://www.sagehill.net/docbookxsl/ToolsSetup.html#InstallDTD
}


function asciidoc-clone-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="asciidoc"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  _que="Clone ${_prog} repo"
  _msg="Skipping cloning ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Cloning ${_prog} repo..."
    ${_prog}-clone
  } || lsd-mod.log.echo "${_msg}"

  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && {
    lsd-mod.log.echo "Installing..."
    __${_prog}-install
  } || lsd-mod.log.echo "${_msg}"
}

asciidoc-clone-install.main "$@"
