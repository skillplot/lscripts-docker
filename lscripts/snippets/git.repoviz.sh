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



function git.repoviz._exec() {
  # echo "$(date -d now +'%d%m%y_%H%M%S')"
  local _timestamp=$(_date_.get__timestamp_millisec)
  echo "${_timestamp}"
  gource -s 2 -a 1 ./ -1920x1080 -o - | \
    ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 23 -threads 0 -bf 0 gource-${_timestamp}.mp4
}


function git.repoviz.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/../lscripts.config.sh
  
  local _cmd="gource"
  _log_.info "Verifying ${_cmd} installation..."
  type ${_cmd} &>/dev/null || _log_.fail "${_cmd} not installed or corrupted!"
  
  _cmd="ffmpeg"
  _log_.info "Verifying ${_cmd} installation..."
  type ${_cmd} &>/dev/null || _log_.fail "${_cmd} not installed or corrupted!"

  git.repoviz._exec
}

git.repoviz.main
