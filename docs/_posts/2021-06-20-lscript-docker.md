---
title: Lscript Docker
date: "2021-06-20 09:00:00 +0530"
categories:
  - Lscripts-docker
tags:
  - lscripts-docker
toc: true
---

## Overview

1. Install nvidia-driver
2. Install docker (community edition), docker-compose (optional) and nvidia-docker-toolkit on the host machine.
3. Build Nvidia CUDA Docker Images
4. [CI/CD](https://gitlab.com/nvidia/container-images/cuda/blob/master/README_CICD.md)


## Installation

This is for **advance** usage providing granular control on specific software component that is to be installed.

1. Install Nvidia driver
    ```bash
    lsd-install.nvidia-driver
    ```
2. Install docker, docker-compose
    ```bash
    lsd-install.docker-ce
    lsd-install.docker-compose
    ```
3. Install Nvidia container toolkit
    ```bash
    lsd-install.nvidia-container-toolkit
    ```

## Build Nvidia CUDA Docker Images
> Only for Nvidia GPU

If looking to use GPU docker containers and have **Nvidia** Graphics card, multiple CUDA stack can be installed and used in parallel using Nvidia GPU docker containers.

These provides complete development stack for deep learning docker environments. Any AI frameworks can be added on top of it and currently provides pre-configuration for Pytorch, Keras and Tensorflow AI frameworks.

* **Pre-requites**
    * Nvidia Driver
    * Docker
    * Nvidia runtime (or nvidia container toolkit which comes with the runtime)
* **Build CUDA 10.0 Nvidia image**
    ```bash
    ## create the external directory, inside this clone the official nividia container file repo
    mkdir -p external
    cd external
    git clone https://gitlab.com/nvidia/container-images/cuda.git
    ##
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
  * Re-start host docker service if Internet access is not there inside container;
      ```bash
      sudo service docker stop
      sudo service docker start
      #
      bash start.bzohub-170820_051654.sh
      #
      docker exec -u $(id -u):$(id -g) -it c1c80473e63c /bin/bash && xhost -local:root 1>/dev/null 2>&1
      docker exec -u $(id -u):$(id -g) -it bzohub-170820_051654 /bin/bash && xhost -local:root 1>/dev/null 2>&1
      ```


## `lsd-docker` Commands

* Quick Commands:
    ```bash
    lsd-docker.osvers
    #
    lsd-docker.cfg
    lsd-docker.container.delete-all
    lsd-docker.container.delete-byimage
    lsd-docker.container.exec-byname
    lsd-docker.container.list
    lsd-docker.container.list-ids
    lsd-docker.container.list-ids-all
    lsd-docker.container.status
    lsd-docker.container.stop-all
    lsd-docker.container.test
    ```
