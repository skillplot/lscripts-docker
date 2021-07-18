---
layout: post
title:  "Quick start"
date:   2021-05-08 05:20:25 +0530
categories: quick-start
---


## Installation


1. Clone the repo
  ```bash
  git clone https://github.com/skillplot/lscripts-docker.git
  ```
2. Put the following in the end of the `~/.bashrc` file. Change the path where you cloned the repo:
  ```bash
  export LSCRIPTS_DOCKER="/<change_this_to_path_absolute_path>/lscripts-docker"
  [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
  ```


## Verify Installation

* To quickly test for different shell modules and functions, check through testing module:
  ```bash
  lsd-test.argparse
  lsd-test.cuda_config_supported
  lsd-test._dir_
  lsd-test.echo
  lsd-test._fio_
  lsd-test._log_
  lsd-test._system_
  ```


## Lscripts Commands

* Lscripts commands available at the disposal with prefix `lsd-`. All th namespaces are:
    * `lsd-apt`
    * `lsd-cd`
    * `lsd-cmd`
    * `lsd-date`
    * `lsd-docker`
    * `lsd-id`
    * `lsd-image`
    * `lsd-install`
    * `lsd-ls`
    * `lsd-nvidia`
    * `lsd-prog`
    * `lsd-python`
    * `lsd-rm`
    * `lsd-select`
    * `lsd-stack`
    * `lsd-system`
    * `lsd-test`
    * `lsd-trash`
* `lsd-cd` - change to the cloned directory`${LSCRIPTS_DOCKER}/lscripts` directory.
* `lsd-ls` - It is at core `ls -ltr` plus wit numeric permission value added as the first column i.e. `644 -rw-r--r--`
* Lscripts configuration variables: `lsd-cfg.`
  ```bash
  lsd-cfg.color
  lsd-cfg.docker
  lsd-cfg.nvidia
  lsd-cfg.system
  lsd-cfg.typeformats
  ```
* Change directories:
  ```bash
  lsd-cd
  ```
* Quick Commands:
  ```bash
  lsd-cmd.dummy
  lsd-cmd.git.get.repo-urls
  lsd-cmd.gitlab.get.cert
  lsd-cmd.git.repoviz
  lsd-cmd.menu-navigation
  lsd-cmd.monitoring-cmds
  lsd-cmd.mount.smb
  lsd-cmd.mount.ssh
  lsd-cmd.pm
  lsd-cmd.python.list.venv
  lsd-cmd.python.venvname.generate
  ##
  lsd-date.cfg
  lsd-date.timestamp
  lsd-date.timestamp.microsec
  lsd-date.timestamp.millisec
  lsd-date.timestamp.nanosec
  ##
  lsd-python.create.virtualenv
  ##
  lsd-nvidia.cfg
  lsd-nvidia.cuda.avail
  lsd-nvidia.cuda.vers
  lsd-nvidia.driver.avail
  lsd-nvidia.gpu.info
  lsd-nvidia.gpu.stats
  ##
  lsd-select.bazel
  lsd-select.cuda
  lsd-select.gcc
  ##
  lsd-system.cfg
  lsd-system.cpu.cores
  lsd-system.cpu.threads
  lsd-system.df.json
  lsd-system.ip
  lsd-system.osinfo
  ##
  lsd-test.argparse
  lsd-test.cuda_config_supported
  lsd-test._dir_
  lsd-test.echo
  lsd-test._fio_
  lsd-test._log_
  lsd-test._system_
  ##
  lsd-utils.date.get
  #
  lsd-utils.id.filename
  lsd-utils.id.filename-tmp
  lsd-utils.id.get
  lsd-utils.id.salt
  lsd-utils.id.uuid
  #
  lsd-utils.image.pdf
  lsd-utils.image.resize
  #
  lsd-utils.kill
  lsd-utils.kill.python
  #
  lsd-utils.ls
  lsd-utils.ls.egg
  lsd-utils.ls.pycache
  #
  lsd-utils.pid
  #
  lsd-utils.rm.egg
  lsd-utils.rm.pycache
  #
  lsd-utils.system.info
  #
  lsd-utils.trash
  ```
* One can combine the output of above commands with other system commands/utilities, example:
    * To parse the `json` output to human readable format using `jq`
      ```bash
      ## install jq - command line json parser util
      # sudo apt -y install jq
      lsd-system.df.json | jq
      ```


## Execute any `lscripts` functions as a command

This is used extensively to create alias for different namespace based commands. Though one can execute the script directly.

* **Quick test: `_fio_.exec_cmd_test`**
  ```bash
  ## Test for executing any function from the lscripts framework
  ## key/value parameter passing (valid scenarios)
  bash lscripts/exec_cmd.sh --cmd=_fio_.exec_cmd_test --name=blah --age=100
  bash lscripts/exec_cmd.sh cmd=_fio_.exec_cmd_test name=blah --age=100
  bash lscripts/exec_cmd.sh cmd=_fio_.exec_cmd_test --name=blah --age=100
  ```
* **Test the Debugger and logger**
  ```bash
  ## execute debug module invoked from command line directly
  bash lscripts/exec_cmd.sh --cmd=_fio_.debug_logger
  ```
* **Utility examples**
  ```bash
  ## NVIDIA gpu stats
  bash lscripts/exec_cmd.sh --cmd=_nvidia_.get__gpu_stats
  ```
