---
layout: post
title:  "Quick start"
date:   2021-05-08 05:20:25 +0530
categories: quick-start
---


## Quick start


1. Clone the repo
2. Put the following in the end of the `~/.bashrc` file. Change the path where you cloned the repo:
    ```bash
    export LSCRIPTS_DOCKER="/path/to/lscripts-docker"
    [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
    ```
3. Quick test
  ```bash
  ## Test cases for different modules (currently not available as execution command )
  bash lscripts/tests/test-1-fio.sh
  bash lscripts/tests/test-1-log.sh
  ```

## Execute any lscripts functions as a command

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



## System Setup

Build and setup a system with required software utilities.

* **NOTE:**
  * Use of logger is mandatory; to invoke any of the scripts dependently
  * If cuda-stack is uninstalled, repo has to be added again when installing it again
  * Lower cuda version to be installed first; if you need multiple cuda installation; downgrades are not possible
  * When more then one cuda is installed; when prompted, should select yes to configure multiple-cuda in order to select the appropriate cuda being installed before verifying it
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


### **a) Full-stack setup**

This is preferred for first time setup for full stack development build.

```bash
bash stack-full-setup.sh
```

### **b) Chose Items individually from full stack**

This is **recommended** for first time setup and gives more control to select what will be installed.

```bash
bash stack-item-setup.sh
```


### **c) Custom - chose whatever you want; examples: -**

This is for **advance** usage providing granular control on specific software component that is to be installed.

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


### Build Nvidia CUDA Docker Images

If looking to use GPU docker containers and have **Nvidia** Graphics card, multiple CUDA stack can be installed and used in parallel using Nvidia GPU docker containers.

These provides complete development stack for deep learning docker environments. Any AI frameworks can be added on top of it and currently provides pre-configuration for Pytorch, Keras and Tensorflow AI frameworks.


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
