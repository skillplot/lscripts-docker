---
layout: post
title:  "System Setup:Prerequisite"
date:   2021-07-04 18:38:26 +0530
categories: tools, prerequisite
---


## Identify the `LINUX_VERSION`

```bash
type lsb_release &>/dev/null && LINUX_VERSION="$(lsb_release -sr)" || {
  LINUX_VERSION=$(. /etc/os-release;echo ${VERSION_ID})
}
```


## prerequisite

```bash
sudo apt -y install libxml2-dev
# sudo apt -y install liblas-dev # some issue with libght
sudo apt -y install libcunit1 libcunit1-dev

sudo apt -y install lzma

sudo apt -y install libmpich-dev
sudo apt -y install libcgal-dev
#
sudo apt -y install libxerces-c-dev
sudo apt -y install libjsoncpp-dev
#
sudo apt -y install libqt5x11extras5-dev
sudo apt -y install qttools5-dev
#
sudo apt -y install libsuitesparseconfig4.4.6 libsuitesparse-dev
sudo apt -y install metis libmetis-dev
#
sudo apt -y install maven
sudo apt -y install openssh-server openssh-client
sudo apt -y install libssl-dev libsslcommon2-dev
sudo apt -y install pkg-config
sudo apt -y install libglfw3 libglfw3-dev

## https://www.pyimagesearch.com/2015/08/24/resolved-matplotlib-figures-not-showing-up-or-displaying/
## https://github.com/tctianchi/pyvenn/issues/3
sudo apt -y install tcl-dev tk-dev python-tk python3-tk
#
sudo apt -y install autoconf automake libtool curl unzip
#
## ceres-solver dependencies
## Todo: Error fix in Ubuntu 20.04; E: Unable to locate package python-gflags
# sudo apt -y install libgflags2.2 libgflags-dev python-gflags python3-gflags libgoogle-glog-dev
sudo apt -y install libgflags2.2 libgflags-dev python3-gflags libgoogle-glog-dev
#
## apache superset (visulization tool in python)
# sudo apt -y install libssl-dev libffi-dev libsasl2-dev libldap2-dev 
```


## prerequisite-pcl


```bash
###----------------------------------------------------------
## PCL Pre-requisite
###----------------------------------------------------------
#
## References:
## * http://pointclouds.org/downloads/linux.html
#
## Setup Prerequisites
## * https://larrylisky.com/2016/11/03/point-cloud-library-on-ubuntu-16-04-lts/
#
## As binaries
## `sudo add-apt-repository -y ppa:v-launchpad-jochen-sprickerhof-de/pcl`
## `sudo apt update`
## `sudo apt -y install libpcl-all`
###----------------------------------------------------------

sudo apt -y update
sudo apt -y install git build-essential linux-libc-dev
sudo apt -y install cmake cmake-gui 
sudo apt -y install libusb-1.0-0-dev libusb-dev libudev-dev
sudo apt -y install mpi-default-dev openmpi-bin openmpi-common  

if [[ ${LINUX_VERSION} == "16.04" ]]; then
  sudo apt -y install libflann1.8 libflann-dev
  sudo apt -y install libvtk5.10-qt4 libvtk5.10 libvtk5-dev
fi

if [[ ${LINUX_VERSION} == "18.04" ]]; then
  sudo apt -y install libflann1.9 libflann-dev
  sudo apt -y install libvtk7.1 libvtk7-dev libvtk7.1-qt libvtk7-qt-dev libvtk7-java libvtk7-jni
fi

sudo apt -y install libeigen3-dev
sudo apt -y install libboost-all-dev

sudo apt -y install libqhull* libgtest-dev
sudo apt -y install freeglut3-dev pkg-config
sudo apt -y install libxmu-dev libxi-dev 
sudo apt -y install mono-complete
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
