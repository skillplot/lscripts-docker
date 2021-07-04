---
layout: post
title:  "System Setup:Prerequisite PCL"
date:   2021-07-05 03:00:00 +0530
categories: prerequisite, pcl
---


## Identify the `LINUX_VERSION`

```bash
type lsb_release &>/dev/null && LINUX_VERSION="$(lsb_release -sr)" || {
  LINUX_VERSION=$(. /etc/os-release;echo ${VERSION_ID})
}
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
