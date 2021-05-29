#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## gource utilitity to visualize git repo
###----------------------------------------------------------
#
## Referenecs:
## * https://www.ekreative.com/blog/producing-your-own-git-repository-animated-visualization-video/
## * https://gource.io/
## * https://github.com/acaudwell/Gource
## * https://github.com/acaudwell/Gource/blob/master/INSTALL
#
## SDL 2.0 (libsdl2-dev)
## SDL Image 2.0 (libsdl2-image-dev)
## PCRE (libpcre3-dev)
## Freetype 2 (libfreetype6-dev)
## GLEW (libglew-dev)
## GLM >= 0.9.3 (libglm-dev)
## Boost Filesystem >= 1.46 (libboost-filesystem-dev)
## PNG >= 1.2 (libpng-dev)
#
## Resollutions presets:
## 1280x720
## 1920×1080
## 640x480
###----------------------------------------------------------

## https://video.stackexchange.com/questions/12520/gource-and-ffmpeg-reduce-video-size
## -preset
## Use the slowest preset that is fast enough that it does not drop frames. You can see if ffmpeg is dropping frames in the console output (if I recall correctly). Presets are: ultrafast, superfast, veryfast, faster, fast, medium, slow, slower, veryslow.

## -crf
## Use the highest -crf value that still provides an acceptable quality level. Range is 0-51. 0 is lossless, 18 is generally considered to be visually lossless or nearly so, 23 is default, and 51 is worst quality. Using a value of 1 will likely result in a huge file.

# gource -s 2 -a 1 ./ -1920x1080 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 23 -threads 0 -bf 0 gource.mp4


# gource $LOG_FILE --log-format custom --stop-at-end --caption-file ${FILENAME}_captions.log --caption-duration 3 --title $TITLE --seconds-per-day 0.7 --auto-skip-seconds 1 --date-format\
#  "%d/%m/%y" --hide "mouse,progress" --user-scale 0.6 --caption-size 20 -1380x950 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420\
# p -crf 1 -threads 4 -bf 0 $FILENAME.mp4


# gource -1280x720 \
#     --stop-at-end \
#     --seconds-per-day 0.2 \
#     -a 1 \
#     -o - \
#     | ffmpeg -y \
#     -r 60 \
#     -f image2pipe \
#     -vcodec ppm \
#     -i - \
#     -vcodec libx264 \
#     -preset fast \
#     -crf 18 \
#     -threads 0 \
#     -bf 0 \
#     -pix_fmt yuv420p \
#     -movflags \
#     +faststart \
#     output.mp4
###----------------------------------------------------------


function __gource-pre_requisite() {
  ## Todo: check if exists and if not, then install them
  sudo apt -y install libglew-dev
  sudo apt -y install libsdl2-dev libsdl2-image-dev libpcre3-dev libfreetype6-dev libglew-dev libglm-dev libboost-filesystem-dev libpng-dev
}


function __gource-build() {
  local DIR="Gource"
  local PROG_DIR="${_LSD__EXTERNAL_HOME}/${DIR}"

  local URL="https://github.com/acaudwell/${DIR}.git"

  _log_.info "Number of threads will be used: ${NUMTHREADS}"
  _log_.info "BASEPATH: ${_LSD__EXTERNAL_HOME}"
  _log_.info "URL: ${URL}"
  _log_.info "PROG_DIR: ${PROG_DIR}"

  # source ${LSCRIPTS}/partials/gitclone.sh

  # ## TOD: check if clone is not completed successfully, then dir would alread exists, but then build will fail
  cd ${PROG_DIR}
  # git pull
  # # local GOURCE_REL="gource-0.51"
  # # git checkout ${GOURCE_REL}

  _log_.echo "Executing: ./autogen.sh"
  make clean
  ./autogen.sh

  _log_.echo "Executing: ./configure"

  ## directory.hpp:270: undefined reference to `boost::filesystem::detail::directory_iterator_construct
  ## libboost_filesystem.a
  # https://stackoverflow.com/questions/47281362/usr-include-boost-filesystem-path-hpp307-undefined-reference-to-boostfiles
  # https://unix.stackexchange.com/questions/149359/what-is-the-correct-syntax-to-add-cflags-and-ldflags-to-configure

  ## ./configure
  ./configure CFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib"

  ## custom configuration path
  # ./configure --prefix=/somewhere/else/than/usr/local

  ## To build using GNU FreeFont TTF Fonts on your system
  # ./configure --enable-ttf-font-dir=/path/to/freefont/

  ## To build with a different font
  # ./configure --enable-font-file=/path/to/alternate/font.ttf

  ## To build against the system version of the TinyXML
  # ./configure --with-tinyxml


  make -j${NUMTHREADS}
  make check -j${NUMTHREADS}

  # # make DESTDIR=/somewhere/custom/path install -j${NUMTHREADS}
  sudo make install -j${NUMTHREADS}
  # sudo ldconfig # refresh shared library cache

  # cd ${LSCRIPTS}
}


function gource-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  _log_.debug "executing script...: ${scriptname}"

  local _prog="gource"

  _log_.info "Clone & compile ${_prog}..."
  _log_.warn "sudo access is required to install the compiled code!"

  local _default=yes
  local _que
  local _msg

  _que="Clone & compile ${_prog} now"
  _msg="Skipping ${_prog} clonning & compiling!"
  _fio_.yesno_${_default} "${_que}" && {
      _log_.echo "Installing pre-requisites..."
      # __${_prog}-pre_requisite

      _log_.echo "Cloning & compiling..."
      __${_prog}-build
    } || _log_.echo "${_msg}"

}

gource-install

