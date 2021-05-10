#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install multimedia softwares
###----------------------------------------------------------


function stack-setup-graphics() {
  local LSCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
  source "${LSCRIPTS}/lscripts/_common_.sh"

  declare -a _stack_install=(
    ###----------------------------------------------------------    
    ## "stack-setup-multimedia"
    ###----------------------------------------------------------
    "vlc-apt"
    "ffmpeg-apt"
    "videofix-apt"
    "obsstudio-ppa"
    "slowmovideo-ppa"
    "youtubedl-apt"
    ###----------------------------------------------------------
    ## "image editors"
    ###----------------------------------------------------------
    "inkscape-graphics-apt"
    "imageviewer-cmdline-apt"
    "imagemagic-graphics-apt"
    "gimp-graphics-apt"
    "krita-ppa"
    "digikam-apt"
    "darktable-apt"
    "xnview-wget"
    ###----------------------------------------------------------
    ## "screenshot, screen-recorders"
    ###----------------------------------------------------------
    "shutter-ppa"
    "simplescreenrecorder-ppa"
    "vokoscreen-ppa"
    ###----------------------------------------------------------
    ## "video editors"
    ###----------------------------------------------------------
    "handbrake-ppa"
    "pitvi-flatpak"
    "openshot-ppa"
    "shotcut-wget"
    ###----------------------------------------------------------
    ## "home theater"
    ###----------------------------------------------------------
    "kodi-multimedia-apt"
    ###----------------------------------------------------------
    ## "audio editors"
    ###----------------------------------------------------------
    "audacity-apt"
    ###----------------------------------------------------------    
    ## "cad, 3D tools"
    ###----------------------------------------------------------
    "freecad-ppa"
    "librecad-ppa"
    "openscad-ppa"
    "makehuman3d-ppa"
  )

  # declare -a _stack_verify=()

  _log_.warn "Install ${FUNCNAME[0]}; sudo access is required!"
  _fio_.yesno_yes "Continue" && {
    local item
    for item in "${_stack_install[@]}";do
      _log_.info ${item}
      local _item_filepath="${LSCRIPTS}/lscripts/${item}-install.sh"

      _log_.echo "Checking for installer..." && \
      ls -1 "${_item_filepath}" 2>/dev/null && {
        _fio_.yesno_no "Install ${item}" && {
          _log_.ok "Executing installer... ${_item_filepath}" && \
          _log_.echo "Installing..."
          source "${_item_filepath}" || _log_.error "${_item_filepath}"
        } || _log_.echo "Skipping ${item} installation!"
      } || _log_.error "Installer not found: ${item}!"
    done
  } || _log_.echo "Skipping ${FUNCNAME[0]} installation!"
}

stack-setup-graphics
