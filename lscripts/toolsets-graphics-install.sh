#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Graphics Toolsets
###----------------------------------------------------------
#
## BD: create a script to install selected packages from the pre-defined list and/or
## give user option to select which to install
##----------------------------------------------------------


function toolsets-graphics-install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  source ${LSCRIPTS}/gimp.graphics.install.sh
  source ${LSCRIPTS}/imagemagic.install.sh
  source ${LSCRIPTS}/inkscape.graphics.install.sh
  source ${LSCRIPTS}/krita.graphics.install.sh

  sudo apt -y install darktable
  sudo apt -y install digikam

  ## TBD to put in multimedia toolsets - video editors, plugins, video streaming
  source ${LSCRIPTS}/ffmpeg.install.sh
  source ${LSCRIPTS}/handbrake.video-transcoder.sh
  source ${LSCRIPTS}/openshot.install.sh
  source ${LSCRIPTS}/slowmovideo.install.sh
  source ${LSCRIPTS}/obs-studio.videoediting.install.sh

  # Video Players
  source ${LSCRIPTS}/vlc.install.sh

  # Screen recorders
  source ${LSCRIPTS}/vokoscreen.screen-recorder.install.sh

  ##
  source ${LSCRIPTS}/youtubedl.video.sh

  ## 3D
  source ${LSCRIPTS}/makehuman.3d.install.sh
  # source ${LSCRIPTS}/meshlab.install.sh

  ## CAD
  source ${LSCRIPTS}/openscad.cad.install.sh
}

toolsets-graphics-install
