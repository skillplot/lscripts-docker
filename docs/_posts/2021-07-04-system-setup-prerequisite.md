---
layout: post
title:  "System Setup:Prerequisite"
date:   2021-07-05 02:30:30 +0530
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
