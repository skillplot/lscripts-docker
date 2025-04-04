#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## sensors
###----------------------------------------------------------
#
## References:
## * https://itsfoss.com/check-laptop-cpu-temperature-ubuntu/
## sudo nvme smart-log /dev/nvme0 | grep temperature
###----------------------------------------------------------


function monitoring_system_sensors-apt-install.main() {
  #sudo apt -y update

  ## System Sensor monitors - temperature
  sudo apt -y install lm-sensors
  sudo apt -y install psensor

  # sudo sensors-detect
  # watch -n 2 sensors
  # watch -n 2 nvidia-smi

  ## System Resource Monitoring
  sudo apt -y install htop atop dstat
  sudo apt -y install smartmontools
  sudo apt -y install nvme-cli

  # dstat -ta --top-cpu
  # dstat -tcmndylp --top-cpu

  # cat /proc/loadavg
  # cat /proc/meminfo


  # [[ "${LINUX_VERSION}" < "22.04" ]] && {
  #   sudo apt -y install  hddtemp
  # }
}

monitoring_system_sensors-apt-install.main "$@"
