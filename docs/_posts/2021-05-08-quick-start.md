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
  ## Replace /codehub with your desired basepath
  export __CODEHUB_ROOT__="/codehub"
  export __LSCRIPTS_DOCKER="${__CODEHUB_ROOT__}/external/lscripts-docker"
  [ -f ${LSCRIPTS__DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS__DOCKER}/lscripts/lscripts.env.sh
  ```


## Verify Installation

* To quickly test for different shell modules and functions, check through testing module:
  ```bash
  lsd-test.argparse
  lsd-test.cuda_config_supported
  lsd-test.dir
  lsd-test.echo
  lsd-test.fio
  lsd-test.log
  lsd-test.system
  ```


## Lscripts Commands

* Lscripts commands available at the disposal with prefix `lsd-`. All th namespaces are:
    * `lsd-admin`
    * `lsd-apt`
    * `lsd-cd`
    * `lsd-cfg`
    * `lsd-cmd`
    * `lsd-cuda`
    * `lsd-date`
    * `lsd-dir`
    * `lsd-docker`
    * `lsd-docs`
    * `lsd-git`
    * `lsd-install`
    * `lsd-lscripts`
    * `lsd-mod` => not to be used directly. It's a namespace for core modules.
    * `lsd-nvidia`
    * `lsd-python`
    * `lsd-select`
    * `lsd-stack`
    * `lsd-system`
    * `lsd-test`
    * `lsd-utils`
* `lsd-cd` - change to the cloned directory`${LSCRIPTS__DOCKER}/lscripts` directory.
* `lsd-ls` - It is at core `ls -ltr` plus wit numeric permission value added as the first column i.e. `644 -rw-r--r--`
* Lscripts configuration variables: `lsd-cfg.`
  ```bash
  lsd-cfg.basepath
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
  lsd-admin.create-login-user
  lsd-admin.create-nologin-user
  ##
  lsd-admin.mkalias-datadirs
  lsd-admin.mkalias-osdirs
  lsd-admin.mkdir-datadirs
  lsd-admin.mkdir-osdirs
  ##
  lsd-admin.restrict-cmds-for-sudo-user
  ##
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
  lsd-cuda.admin.__purge_cuda_stack
  lsd-cuda.avail
  lsd-cuda.cfg
  lsd-cuda.config
  lsd-cuda.select
  lsd-cuda.verify
  lsd-cuda.vers
  ##
  lsd-date.cfg
  lsd-date.get
  lsd-date.get-blog
  lsd-date.get-full
  lsd-date.timestamp
  lsd-date.timestamp.microsec
  lsd-date.timestamp.millisec
  lsd-date.timestamp.nanosec
  ##
  lsd-dir.cfg
  lsd-dir.admin.mkalias-datadirs
  lsd-dir.admin.mkalias-osdirs
  lsd-dir.admin.mkdir-datadirs
  lsd-dir.admin.mkdir-osdirs
  lsd-dir.get-datadirs-paths
  lsd-dir.get-osdirs-paths
  ##
  lsd-docs.admin.update
  lsd-docs.cmds
  lsd-docs.mkdocs
  lsd-docs.mkdocs.deploy
  lsd-docs.mkdocs.link
  ##
  lsd-python.create.virtualenv
  lsd-python.create.virtualenv --path=/usr/bin/python2
  lsd-python.kill
  lsd-python.ls.egg
  lsd-python.ls.pycache
  lsd-python.rm.egg
  lsd-python.rm.pycache
  lsd-python.test.virtualenv
  lsd-python.test.virtualenv --path=/usr/bin/python2
  lsd-python.venv.list
  lsd-python.venv.name
  lsd-python.venv.name --path=/usr/bin/python2
  ##
  lsd-nvidia.cfg
  lsd-nvidia.driver.avail
  lsd-nvidia.gpu.info
  lsd-nvidia.gpu.stats
  ##
  lsd-select.bazel
  lsd-select.cuda
  lsd-select.gcc
  ##
  lsd-system.admin.create-login-user
  lsd-system.admin.create-nologin-user
  lsd-system.admin.restrict-cmds-for-sudo-user
  lsd-system.cfg
  lsd-system.cpu.cores
  lsd-system.cpu.threads
  lsd-system.df.json
  lsd-system.info
  lsd-system.ip
  lsd-system.osinfo
  ##
  lsd-test.argparse
  lsd-test.cuda_config_supported
  lsd-test.dir
  lsd-test.echo
  lsd-test.fio
  lsd-test.log
  lsd-test.system
  ##
  lsd-utils.cmds
  #
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
  lsd-utils.python.venvname
  #
  lsd-utils.rm.egg
  lsd-utils.rm.pycache
  #
  lsd-utils.system.info
  #
  lsd-utils.trash
  #####
  lsd-lscripts.alias.main
  lsd-lscripts.env.main
  lsd-lscripts.exe.install
  lsd-lscripts.exe.main
  lsd-lscripts.install.__itemwise
  lsd-lscripts.install.main
  lsd-lscripts.install.__menu
  lsd-lscripts.install.__stacksetup
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

* **Quick test: `lsd-mod.fio.exec_cmd_test`**
  ```bash
  ## Test for executing any function from the lscripts framework
  ## key/value parameter passing (valid scenarios)
  bash lscripts/exec_cmd.sh --cmd=lsd-mod.fio.exec_cmd_test --name=blah --age=100
  bash lscripts/exec_cmd.sh cmd=lsd-mod.fio.exec_cmd_test name=blah --age=100
  bash lscripts/exec_cmd.sh cmd=lsd-mod.fio.exec_cmd_test --name=blah --age=100
  ```
* **Test the Debugger and logger**
  ```bash
  ## execute debug module invoked from command line directly
  bash lscripts/exec_cmd.sh --cmd=lsd-mod.fio.debug_logger
  ```
* **Utility examples**
  ```bash
  ## NVIDIA gpu stats
  bash lscripts/exec_cmd.sh --cmd=_nvidia_.get__gpu_stats
  ```

## Other Configuration through environment variables


* You can put the following in the end of the `~/.bashrc` file, to change the behavior of the `lscripts-docker`:
  ```bash
  ###True=1; False=0
  export LSCRIPTS__DEBUG=1
  ## [1]="CRITICAL"
  ## [2]="ERROR"
  ## [3]="WARNING"
  ## [4]="INFO"
  ## [5]="OK"
  ## [6]="SUCCESS"
  ## [7]="DEBUG"
  ## [8]="STACKTRACE"
  export LSCRIPTS__LOG_LEVEL=3
  ## This is when requiring to build and compile external softwares
  export LSCRIPTS__BASENAME="lscripts"
  export LSCRIPTS__ROOT="<change_this_to_path_absolute_path>"
  ```

## Environment variables

Additionally following environment variables can help you customize the `lscripts-docker` based workspace setup and configurations.
```bash
LSCRIPTS__BASENAME
LSCRIPTS__ROOT
LSCRIPTS__BANNER
LSCRIPTS__BANNER_TYPE
LSCRIPTS__DEBUG
LSCRIPTS__LOG_LEVEL
LSCRIPTS__VMHOME
LSCRIPTS__PYVENV_PATH
LSCRIPTS__WSGIPYTHONPATH
LSCRIPTS__WSGIPYTHONHOME
LSCRIPTS__ANDROID_HOME
LSCRIPTS__APACHE_HOME
LSCRIPTS__WWW_HOME
LSCRIPTS__DOWNLOADS
LSCRIPTS__EXTERNAL_HOME
```
