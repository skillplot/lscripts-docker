#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Utilility functions for nvidia, cuda, gpu
## cuda, cudnn, tensorrt is referred as 'cuda-stack'
###----------------------------------------------------------


function _nvidia_.get__cuda_vers() {
  local ver
  declare -a cuda_vers=(`echo $( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )/../config/${LINUX_DISTRIBUTION}/cuda-cfg-[0-9]*.sh | grep -o -P "(\ *[0-9.]*sh)" | sed -r 's/\.sh//'`)
  # (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  # for ver in "${cuda_vers[@]}"; do
  #   (>&2 echo -e "ver => ${ver}")
  # done
  echo "${cuda_vers[@]}"
}


function _nvidia_.get__cuda_vers_avail() {
  local ver
  declare -a cuda_vers_avail=(`echo $(ls -d /usr/local/cuda-* | cut -d'-' -f2)`)
  # (>&2 echo -e "Total cuda_vers: ${#cuda_vers[@]}\n cuda_vers: ${cuda_vers[@]}")
  # for ver in "${cuda_vers_avail[@]}"; do
  #   (>&2 echo -e "ver => ${ver}")
  # done
  echo "${cuda_vers_avail[@]}"
}


function _nvidia_.get__driver_avail() {
  declare -a nvidia_driver_avail=($(apt-cache search nvidia-driver | grep -Eo "^nvidia-driver-[0-9]+\s" | cut -d'-' -f3 | sort))
  echo "${nvidia_driver_avail[@]}"
}


function _nvidia_.get__driver_info() {
  ###----------------------------------------------------------
  ## After successful Nvidia Driver installation
  ## check version of Driver installed
  ###----------------------------------------------------------

  _log_.info "Checking for version of Driver installed..."
  nvidia-settings -q gpus

  # show all attributes
  #info ""
  #info "show all attributes"
  #nvidia-settings -q all

  nvidia-smi
  nvidia-smi -q | grep "Driver Version"
  #nvidia-smi -h
  #nvidia-smi --help-query-gpu
  #nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv,noheader
  nvidia-smi --query-gpu=count,gpu_name,memory.total,driver_version,clocks.max.memory,compute_mode --format=csv

  lsmod | grep -i nouveau # this should not return anything

  lsmod | grep -i nvidia # this should not return anything
  ### sample output
  ## nvidia_drm             49152  0
  ## nvidia_modeset       1114112  1 nvidia_drm
  ## nvidia              18808832  1 nvidia_modeset
  ## drm_kms_helper        204800  2 nvidia_drm,i915
  ## ipmi_msghandler        65536  2 ipmi_devintf,nvidia
  ## drm                   487424  6 drm_kms_helper,nvidia_drm,i915

  prime-select query # should return: nvidia
}


function _nvidia_.get__gpu_stats() {
  local _delay=$1
  [[ ! -z ${_delay} ]] || _delay=5
  _log_.debug "_delay: ${_delay} seconds"

  nvidia-smi -L
  # nvidia-smi -L | wc -l

  # https://stackoverflow.com/a/8225492
  # nvidia-smi -q -g 0 -d UTILIZATION -l

  # https://github.com/Syllo/nvtop
  # sudo apt install nvtop
  # https://stackoverflow.com/a/37664194
  # ps f -o user,pgrp,pid,pcpu,pmem,start,time,command -p `lsof -n -w -t /dev/nvidia*`
  # watch -n 0.1 'ps f -o user,pgrp,pid,pcpu,pmem,start,time,command -p `sudo lsof -n -w -t /dev/nvidia*`'


  # watch -n 1 nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu

  ## https://www.slideshare.net/databricks/monitoring-of-gpu-usage-with-tensorflow-models-using-prometheus
  nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,pstate,pcie.link.gen.max,pcie.link.gen.current,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l ${_delay}
  # nvidia-smi --query-gpu=index,timestamp,power.draw,clocks.sm,clocks.mem,clocks.gr --format=csv

  ## https://github.com/teh/nvidia-smi-prometheus/blob/master/src/Main.hs
  # nvidia-smi dmon -c 10


  # chrome://tracing


  # nvidia-smi --help-query-gpu
  # nvidia-smi -l 1
  # watch -n 1 nvidia-smi

  #function _nvidia_.better-nvidia-smi () {
  #    nvidia-smi
  #    join -1 1 -2 3 \
  #        <(nvidia-smi --query-compute-apps=pid,used_memory \
  #                     --format=csv \
  #          | sed "s/ //g" | sed "s/,/ /g" \
  #          | awk 'NR<=1 {print toupper($0)} NR>1 {print $0}' \
  #          | sed "/\[NotSupported\]/d" \
  #          | awk 'NR<=1{print $0;next}{print $0| "sort -k1"}') \
  #        <(ps -a -o user,pgrp,pid,pcpu,pmem,time,command \
  #          | awk 'NR<=1{print $0;next}{print $0| "sort -k3"}') \
  #        | column -t
  #}

  #_nvidia_.better-nvidia-smi


  ## TBD: log gpustats
  #nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l >> hmd-06032019.txt
  #nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -lms >> hmd-06032019.txt



  ## TBD
  ##----------------------  
  # nvidia-smi --format=csv --query-gpu=power.draw,utilization.gpu,fan.speed,temperature.gpu -l 1 -f $1


  ## https://towardsdatascience.com/burning-gpu-while-training-dl-model-these-commands-can-cool-it-down-9c658b31c171
  ## “GPUFanControlState=1” means you can change the fan speed manually, “[fan:0]” means which gpu fan you want to set, “GPUTargetFanSpeed=100” means setting the speed to 100%, but that will be so noisy, you can choose 80%.
  # nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=80"

  ## https://www.andrey-melentyev.com/monitoring-gpus.html
  # https://github.com/Syllo/nvtop#nvtop-build
  # https://github.com/wookayin/gpustat

  # https://timdettmers.com/2018/12/16/deep-learning-hardware-guide/

  # https://developer.android.com/ndk/guides/neuralnetworks
  # https://www.xenonstack.com/blog/log-analytics-deep-machine-learning/
  # https://dzone.com/articles/how-to-train-tensorflow-models-using-gpus
  # https://tutorials.ubuntu.com/tutorial/viewing-and-monitoring-log-files#0
  # https://linoxide.com/linux-command/linux-pidstat-monitor-statistics-procesess/
  # https://www.ubuntupit.com/most-comprehensive-list-of-linux-monitoring-tools-for-sysadmin/ - **best reference**
  # https://www.nagios.com/solutions/linux-monitoring/
  # https://github.com/nicolargo/glances
    # https://glances.readthedocs.io/
    # pip install glances
    # pip install 'glances[action,browser,cloud,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]'

  # https://www.linuxtechi.com/monitor-linux-systems-performance-iostat-command/
  # https://www.linuxtechi.com/generate-cpu-memory-io-report-sar-command/ - **best report generation by hands**

  # cat /etc/sysstat/sysstat
  # sar 2 5 -o /tmp/data > /dev/null 2>&1

  ## https://stackoverflow.com/questions/10508843/what-is-dev-null-21 

  # https://en.wikipedia.org/wiki/Device_file#Pseudo-devices.

  # >> /dev/null redirects standard output (stdout) to /dev/null, which discards it.

  # 2>&1 redirects standard _log_.error (2) to standard output (1), which then discards it as well since standard output has already been redirected.

  # & indicates a file descriptor. There are usually 3 file descriptors - standard input, output, and error.


  # Let's break >> /dev/null 2>&1 statement into parts:

  # Part 1: >> output redirection

  # This is used to redirect the program output and append the output at the end of the file
  # https://unix.stackexchange.com/questions/89386/what-is-symbol-and-in-unix-linux

  # Part 2: /dev/null special file

  # This is a Pseudo-devices special file.

  # Command ls -l /dev/null will give you details of this file:

  # crw-rw-rw-. 1 root root 1, 3 Mar 20 18:37 /dev/null
  # Did you observe crw? Which means it is a pseudo-device file which is of character-special-file type that provides serial access.
  # /dev/null accepts and discards all input; produces no output (always returns an end-of-file indication on a read)

  # Part 3: 2>&1 file descriptor

  # Whenever you execute a program, operating system always opens three files STDIN, STDOUT, and STDERR as we know whenever a file is opened, operating system (from kernel) returns a non-negative integer called as File Descriptor. The file descriptor for these files are 0, 1, 2 respectively.

  # So 2>&1 simply says redirect STDERR to STDOUT

  ## https://linoxide.com/tools/vmstat-graphical-mode/
  ## https://github.com/joewalnes/websocketd


  # https://glances.readthedocs.io/en/stable/cmds.html#interactive-commands


  # https://www.vioan.eu/blog/2016/10/10/deploy-your-flask-python-app-on-ubuntu-with-apache-gunicorn-and-systemd/
  # https://www.linode.com/docs/applications/big-data/how-to-move-machine-learning-model-to-production/
  # https://www.pyimagesearch.com/2018/01/29/scalable-keras-deep-learning-rest-api/
  # https://blog.keras.io/building-a-simple-keras-deep-learning-rest-api.how-to-move-machine-learning-model-to-production
}


function _nvidia_.purge_cuda_stack() {
  local _que="Do you want to purge cuda stack"
  _fio_.yes_or_no_loop "${_que}" && {

    _log_.warn "purging cuda stack..."

    sudo apt -y --allow-change-held-packages remove 'cuda*' \
      'cudnn*' \
      'libcudnn*' \
      'libnccl*' \
      'libnvinfer*'
       # &>/dev/null
    
    sudo rm -rf /usr/local/cuda \
      /usr/local/cuda* 1>&2
    
    _log_.ok "purging cuda stack... completed."
  } || _log_.info "Skipping purging cuda stack."
}


function _nvidia_.purge_nvidia_stack() {
  _log_.warn "purging nvidia driver and cuda, cudnn, tensorrt stack..."

  sudo apt -y --allow-change-held-packages remove 'nvidia-*' \
    'nvidia*' 1>&2

  _nvidia_.purge_cuda_stack
  _log_.ok "purging nvidia stack... completed"
}


function _nvidia_.update_alternatives_cuda() {
  ###----------------------------------------------------------
  ## cuda multiple version configuration
  ## Alternative to update-alternative options is to create sym link
  ## I preferred update-alternatives option
  ##
  ## Examples:
  # ## Todo: autopick cuda version and their priorities based on what is installed in the /usr/local/cuda-xx.y
  # if [ -d /usr/local/cuda-11.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-11.0 250
  # fi
  # if [ -d /usr/local/cuda-10.2 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.2 300
  # fi
  # if [ -d /usr/local/cuda-10.1 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.1 500
  # fi
  # if [ -d /usr/local/cuda-10.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-10.0 200
  # fi
  # if [ -d /usr/local/cuda-9.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-9.0 400
  # fi
  # if [ -d /usr/local/cuda-8.0 ]; then
  #   sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-8.0 50
  # fi
  ###----------------------------------------------------------

  declare -a cuda_vers=($(_nvidia_.get__cuda_vers))
  ## Todo: fix error
  # declare -a weights=($(seq 50 50 `echo (( ${#cuda_vers[@]}*100 ))`))
  declare -a weights=($(seq 50 50 500))

  local ver
  local __count=0
  for ver in "${cuda_vers[@]}"; do
    (>&2 echo -e "cuda-${ver}: ${ver} ${weights[${__count}]}")

    if [[ -d /usr/local/cuda-${ver} ]]; then
      sudo update-alternatives --install /usr/local/cuda cuda /usr/local/cuda-${ver} ${weights[${__count}]}
    fi
    ((__count++))
  done

  sudo update-alternatives --config cuda
}
