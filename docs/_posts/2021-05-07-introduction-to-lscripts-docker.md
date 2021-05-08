---
layout: post
title:  "Introduction to Lscripts Docker!"
date:   2021-05-07 04:43:26 +0530
categories: introduction
---


## Quick start


1. Clone the repo
2. Put the following in the end of the `~/.bashrc` file. Change the path where you cloned the repo:
    ```bash
    export LSCRIPTS_DOCKER="/path/to/lscripts-docker"
    [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
    ```


## System Setup

* **NOTE:**
  * Use of logger is mandatory; to invoke any of the scripts dependently
  * If cuda-stack is uninstalled, repo has to be added again when installing it again
  * Lower cuda version to be installed first; if you need multiple cuda installation; downgrades are not possible
  * When more then one cuda is installed; when prompted, should select yes to configure mutiple-cuda in order to select the appropriate cuda being installed before verifying it
  * The sequencing of the installation is carefully crafted to build the full stack host system with maximum functionality from the compiled software suites
* **Supported CUDA version per system**
  * ubuntu18.04: 9.0, 10.0, 10.2, 11.0
  * ubuntu16.04: 8.0, 9.0, 10.0
  * ubuntu14.04: 8.0, 10.0
  * It's possible to run different cuda versions on each Ubuntu OS, though it may have it's own quirks
* **Required Nvidia driver for different CUDA driver / runtime**
  * 10.0, 410+ driver
  * 10.2, 440+ driver
  * 11.0, 450+ driver
* **a) Full-stack setup**
  ```bash
  bash stack-full-setup.sh
  ```
* **b) Chose Items individually from full stack**
  ```bash
  bash stack-item-setup.sh
  ```
* **c) Custom - chose whatever you want; examples: -**
  ```bash
  bash nvidia-driver-install.sh
  #
  ## bash stack-setup-docker.sh
  bash docker-ce-install.sh
  bash docker-compose-install.sh
  #
  ## 9.0, 10.0, 10.2, 11.0
  bash cuda-stack-install.sh 10.0
  #
  ## installs both python 2 and 3
  bash python-install.sh
  bash python-virtualenvwrapper-install.sh
  ```


## Build Nvidia CUDA Docker Images


* **Build CUDA 10.0 Nvidia image**
  ```bash
  printf "y" | bash docker-buildimg-cuda.sh 10.0
  ```
* **Python dependencies for specific CUDA versions**
  ```bash
  pip install -U -r lscripts/config/ubuntu18.04/python.requirements-ai-cuda-9.0.txt
  pip install -U -r lscripts/config/ubuntu18.04/python.requirements-ai-cuda-10.0.txt
  pip install -U -r lscripts/config/ubuntu18.04/python.requirements-ai-cuda-10.2.txt
  #
  pip install -U -r lscripts/config/ubuntu18.04/python.requirements-ai-cuda-11.0.txt
  ```
* **Docker container tips**
  * Re-start host docker service if internet access is not there inside container;
    ```bash
    sudo service docker stop
    sudo service docker start
    #
    bash start.bzohub-170820_051654.sh
    #
    docker exec -u $(id -u):$(id -g) -it c1c80473e63c /bin/bash && xhost -local:root 1>/dev/null 2>&1
    docker exec -u $(id -u):$(id -g) -it bzohub-170820_051654 /bin/bash && xhost -local:root 1>/dev/null 2>&1
    ```


## System design

* Whenever sudo is required, it's prompted with the reason
* Log with different log levels are available, by default it's enabled with debug
* Error handing with fail scenarios for missing dependency checks and recommendations
* different level of granularity of system setup
* Docker container compliance through modular configurations and environment variables
* Nvidia stack - driver, cuda, cudnn and tensorrt support for the host and docker containers
* Handpicked and tested for different version dependencies
* Tested on Ubuntu 18.04 LTS
* **Execute any lscripts functions as a command**
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
* **Testing modules**
  ```bash
  # Test cases for different modules (currently not available as execution command )
  bash lscripts/tests/test-1-fio.sh
  bash lscripts/tests/test-1-log.sh
  ```
* Utility examples
  ```bash
  ## NVIDIA gpu stats
  bash lscripts/exec_cmd.sh --cmd=_nvidia_.get__gpu_stats
  ```


### Core Configuration Modules: `lscripts/config`

**WARNING:**
* DO NOT change the configuration variable names and imports order
* They are sensitive to the order and sequence in which they are defined, hence changing them will have unexpected consequences
* Be Aware and open the script in editor to understand what it is doing, specifically to dangerous function call that can purge or delete things; also better make them internal functions.


The reason for sensitivity towards order and sequence of definitions and imports is because I created a **Cascading Pattern** in order to pass variables & their respective values between different scripts without leaking them in the global scope or to terminal. There is no simple way to use a shell script as a library module, hence the decision is to focus on flexibility over rigidity, simplicity over complexity and modularity of shell scripts. The success of **cascading pattern** to variable passing is due to the unique name space creation mechanism through **consistent naming conventions** and **namespace scoping**.



* uses shell scripts itself for creating configuration variables and files are named as `<configname>-cfg.sh`
* all variables are in local scope, configuration files cannot be used directly and can be used inside functions only
* all variable names are uppercase
* `color.sh` => `config/color.sh`
  * color codes configurations
* `typeformats.sh` => `config/typeformats.sh`
  * internal usage for dynamic configurations
* wraps all configurations and it's the single entry point: `__init__.sh` => `config/__init__.sh` like:
  * Core configuration
    * system
    * basepath
    * versions
    * nvidia
    * docker
    * python
  * Users configuration
  * MongoDB configuration
  * Docker container configuration


### Core Utility Modules: `lscripts/utils`

* Logger:`_log_.sh`:
  * `lscripts/utils/_log_.sh`
  * log module
* Utility function modules: `_fn_.sh` => `lscipts/utils/_fn_.sh`
  * `_system_.sh` => `lscripts/utils/_system_.sh`
    * system utility module
  * `_fio_.sh` => `lscripts/utils/_fio_.sh`
    * I/O module
  * `_nvidia_.sh` => `lscripts/utils/_nvidia_.sh`
    * nvidia gpu and cuda stack utility module
  * `_docker_.sh` => `lscripts/utils/_docker_.sh`
    * docker utility module


### Common Module

* Common:`_common_.sh`:
  * high level wrapper
  * wraps the code configurations and core utility functions



### Naming conventions

1. Variable names:
  * namespace
    * `LSCRIPTS`: suggested user defined environment variable namespace
      * use this as prefix for custom environment variables
      * or use this as a variable names withing scripts when using `lscripts` as library module
        * as a convention, use uppercase is they are coming from environment variables, constant values or non-function global variables, otherwise use lowercase for variables in local scope, function names 
    * `_LSCRIPTS__`: Environment variables namespace prefix
    * `<modulename>.<function_name>`: all module functions follow this pattern
  * `_<SOME_NAME>` i.e. starting with single `_` underscore
    * these are reserved variable names
    * function names are tucked under module name eg: `_log_.debug` where module name is `_log_.sh`
  * `__<SOME_NAME>` i.e. starting with double `__` underscores
    * these are reserved variable names
    * strictly private scope, overriding these has unexpected impact
    * function names are tucked under module name.
      * These should not be invoked directly and instead their wrapper function to be used eg: `_log_.__failure` where module name is `_log_.sh` is a expected to private, so instead use it's wrapper: `_log_.fail`
  * Environment variables
    * All environment variables that are expected to be customized by user defined values:
      * namespace prefix: `_LSCRIPTS__`
