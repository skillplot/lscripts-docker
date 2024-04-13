 #!/bin/sh

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## ROS Configuration
###----------------------------------------------------------


ROSVER="kinetic"

source /opt/ros/$ROSVER/setup.bash
export ROS_ROOT=/opt/ros/$ROSVER/ros
export PATH=$ROS_ROOT/bin:$PATH
export PYTHONPATH=$ROS_ROOT/core/roslib/src:$PYTHONPATH
export ROS_PACKAGE_PATH=~/ros_workspace:/opt/ros/$ROSVER/stacks:$ROS_PACKAGE_PATH
