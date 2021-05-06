#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## sensors
###----------------------------------------------------------
#
## References:
## * https://itsfoss.com/check-laptop-cpu-temperature-ubuntu/
###----------------------------------------------------------


function monitoring_system_sensors-apt-install() {
  #sudo apt -y update

  ## System Sensor monitors - temperature
  sudo apt -y install lm-sensors hddtemp
  sudo apt -y install psensor

  # sudo sensors-detect
  # watch -n 2 sensors
  # watch -n 2 nvidia-smi

  ## System Resource Monitoring
  sudo apt -y install htop atop dstat

  # dstat -ta --top-cpu
  # dstat -tcmndylp --top-cpu

  # cat /proc/loadavg
  # cat /proc/meminfo
}

monitoring_system_sensors-apt-install
