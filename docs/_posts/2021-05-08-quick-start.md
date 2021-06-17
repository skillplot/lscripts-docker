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
    export LSCRIPTS_DOCKER="/path/to/lscripts-docker"
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

* Lscripts commands available at the disposal with prefix `lsd.` or `lsd-`. All th namespaces are:
    * `lsd.`
    * `lsd-cmd.`
    * `lsd-cfg.`
    * `lsd-install.`
    * `lsd-stack.`
    * `lsd-test.`
* `lsd-cd` - change to the cloned directory `${LSCRIPTS_DOCKER}/lscripts` directory.
* Lscripts configuration variables: `lsd-cfg.`
    ```bash
    lsd-cfg.color
    lsd-cfg.system
    lsd-cfg.typeformats
    ```
* Quick Commands with namespaces: `lsd.` and `lsd-cmd.`
    ```bash
    lsd.prog.ids
    lsd.prog.kill
    ##
    lsd.python.kill
    lsd.python.create.virtualenv
    ##
    lsd.ls.pycache
    lsd.ls.egg
    lsd.ls.mod
    ##
    lsd.rm.pycache
    lsd.rm.egg
    ##
    lsd.image.resize
    lsd.image.pdf
    ##
    lsd.nvidia.gpu.info
    lsd.nvidia.gpu.stats
    lsd.nvidia.cuda.vers
    lsd.nvidia.cuda.avail
    lsd.nvidia.driver.avail
    ##
    lsd.select.cuda
    lsd.select.gcc
    lsd.select.bazel
    ##
    lsd.date.get
    lsd.date.timestamp
    lsd.date.timestamp.millisec
    lsd.date.timestamp.microsec
    lsd.date.timestamp.nanosec
    ##
    lsd.system.info
    lsd.system.cpu.cores
    lsd.system.cpu.threads
    lsd.system.ip
    lsd.system.df.json
    lsd.system.osinfo
    ##
    lsd.docker.osvers
    ##
    lsd-cmd.dummy
    lsd-cmd.git.get.repo-urls
    lsd-cmd.git.repoviz
    lsd-cmd.gitlab.get.cert
    lsd-cmd.menu-navigation
    lsd-cmd.monitoring-cmds
    lsd-cmd.mount.smb
    lsd-cmd.mount.ssh
    lsd-cmd.pm
    lsd-cmd.ppa.get.repo
    lsd-cmd.python.venvname.generate
    lsd-cmd.python.list.venv
    ```
* One can combine the output of above commands with other system commands/utilities, example:
    * To parse the `json` output to human readable format using `jq`
    ```bash
    ## install jq - command line json parser util
    # sudo apt -y install jq
    lsd.system.df.json | jq
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
