---
title: "[Legacy] System Setup:Prerequisite OpenCV"
date: "2021-07-04 09:00:00 +0530"
categories:
  - Archive
  - Lscripts-docker
tags:
  - legacy
  - lscripts-docker
  - prerequisite, opencv
toc: true
---
{: .prompt-warning }
This is an **archived** post migrated from the previous minima-based site. It may describe older workflows or legacy setups.

## Identify the `LINUX_VERSION`

```bash
type lsb_release &>/dev/null && LINUX_VERSION="$(lsb_release -sr)" || {
  LINUX_VERSION=$(. /etc/os-release;echo ${VERSION_ID})
}
```


## prerequisite-opencv

```bash
###----------------------------------------------------------
#
## References:
## * http://www.linuxfromscratch.org/blfs/view/cvs/general/opencv.html
## * http://www.bogotobogo.com/OpenCV/opencv_3_tutorial_ubuntu14_install_cmake.php
## * https://ubuntuforums.org/showthread.php?t=2219550
## * https://github.com/facebook/fbcunn/blob/master/INSTALL.md
## * https://github.com/milq/milq/blob/master/scripts/bash/install-opencv.sh
###----------------------------------------------------------


## INSTALL DEPENDENCIES
sudo apt -y install build-essential cmake git unzip pkg-config qtbase5-dev
sudo apt -y install libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler libopencv-dev

## python
#source ${LSCRIPTS}/python.install.sh

## ffmpeg install
#source ${LSCRIPTS}/ffmpeg.install.sh

sudo apt -y remove x264 libx264-dev
sudo apt -y install checkinstall yasm libjpeg8-dev libjasper-dev libtiff5-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2-dev libv4l-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libqt4-dev libgtk-3-dev libgtk2.0-dev libtbb-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev x264 v4l-utils


sudo apt -y install doxygen doxygen-gui graphviz


# # https://www.learnopencv.com/installing-deep-learning-frameworks-on-ubuntu-with-cuda-support/
sudo apt -y remove x264 libx264-dev
sudo apt -y install checkinstall yasm
sudo apt -y install libjpeg8-dev libjasper-dev


if [[ ${LINUX_VERSION} == "16.04" ]]; then
  echo "...${LINUX_VERSION}"
  sudo apt -y install libpng12-dev
fi
## If you are using Ubuntu 14.04
## sudo apt -y install libtiff4-dev
 
## If you are using Ubuntu 16.04
sudo apt -y install libtiff5-dev
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
 
sudo apt -y install libxine2-dev libv4l-dev
sudo apt -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt -y install libqt4-dev libgtk2.0-dev libtbb-dev
sudo apt -y install libfaac-dev libmp3lame-dev libtheora-dev
sudo apt -y install libvorbis-dev libxvidcore-dev
sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt -y install x264 v4l-utils
```
