#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ROS
###----------------------------------------------------------
#
## References:
## * http://answers.ros.org/question/238763/how-to-install-kinetic-on-ubuntu-14/
## * http://wiki.ros.org/kinetic/Installation
## * http://wiki.ros.org/indigo/Installation/Ubuntu
## * https://roboticslive.cc/2020/04/22/lets-make-robots-01-introduction-to-ros-and-installing/
## * http://wiki.ros.org/melodic/Installation/Ubuntu
#
## The Kinetic installation instructions clearly state that binary packages (apt-get) for ROS Kinetic
## are only available for Ubuntu Wily (15.10) and Xenial (16.04). I'd recommend that you use ROS Indigo
## instead (it is a long-term support release compatible with Ubuntu 14.04)
##----------------------------------------------------------


function ros-apt-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  local ROSVER=''
  case ${LINUX_VERSION} in
    14.04)
      sudo apt -y install ros-indigo-desktop-full
      ROSVER='indigo'
      ;;
    16.04)
      sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu ${LINUX_CODE_NAME} main" > /etc/apt/sources.list.d/ros-latest.list'
      sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
      sudo apt -y update
      sudo apt -y install ros-kinetic-desktop-full
      ROSVER='kinetic'
      ;;
    18.04)
      sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
      # sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
      curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -
      sudo apt -y update
      # sudo apt -y install ros-melodic-desktop-full
      sudo aptitude install ros-melodic-desktop-full
      ROSVER='melodic'
      ;;
    *)
      # leave as-is
      ;;
  esac

  sudo rosdep init
  rosdep update
  rosdep install rviz

  sudo apt -y install python-rosinstall
  sudo apt -y install ros-${ROSVER}-image-view
  sudo apt -y install ros-${ROSVER}-stereo-image-proc0

  sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

  pip install catkin_pkg

}

ros-apt-install.main "$@"
