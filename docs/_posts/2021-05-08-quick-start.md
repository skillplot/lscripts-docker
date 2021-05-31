---
layout: post
title:  "Quick start"
date:   2021-05-08 05:20:25 +0530
categories: quick-start
---


## Quick start


1. Clone the repo
    ```bash
    git clone https://github.com/skillplot/lscripts-docker.git
    ```
2. Put the following in the end of the `~/.bashrc` file. Change the path where you cloned the repo:
    ```bash
    export LSCRIPTS_DOCKER="/path/to/lscripts-docker"
    [ -f ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh ] && source ${LSCRIPTS_DOCKER}/lscripts/lscripts.env.sh
    ```
3. Quick Commands available at the disposal with namespace: `lsd.`
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
    ```
4. Quick test
    ```bash
    ## Test cases for different modules (currently not available as execution command )
    bash lscripts/tests/test._fio_.sh
    bash lscripts/tests/test._log_.sh
    ```


## Quick Software Installation using software stacks

Software stacks are grouping of logical softwares based on their functionalities. Many softwares depends on each other and their are cyclic dependencies. The sequence of items installed using software stacks is done meticulously and it's recommended if you want to setup a complete multi-functional system stacks for development. These choice of packages are meant from development perspective and hence are not optimized for production installation. It's recommended to be prudent and observe the dependencies being installed or un-installed.


* List the all the different software installation stacks grouping
    ```bash
    lsd-stack.list
    ```
* To install individual software stack item
    ```bash
      lsd-stack.list <name_of_the_item>
    ```


## Execute any lscripts functions as a command

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

* **Full-stack**
    ```bash
    lsd-stack.all
    ```
* **Individual stack item**
    ```bash
    lsd-stack.prerequisite
    lsd-stack.nvidia-cuda-python-docker
    lsd-stack.utils
    lsd-stack.sysutils
    lsd-stack.editors
    lsd-stack.markdowneditors
    lsd-stack.programming
    lsd-stack.epub
    lsd-stack.storage
    lsd-stack.multimedia
    lsd-stack.misc
    ```


### **b) Item-wise setup**

This is **recommended** for first time setup and gives more control to select what will be installed.

* **Item-wise stack**
    ```bash
    lsd-stack.itemwise
    ```

### **c) Custom setup - chose whatever you want**

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
3. Install Nvidia docker
    ```bash
    lsd-install.nvidia-container-toolkit
    ```
4. Install python
    ```bash
    ## installs both python 2 and 3
    lsd-install.python
    ```
5. Install python's virtualenv, virtualenvwrapper
  * Python to be installed before installing `python-virtualenvwrapper`
  * Configure the environment variables for `python-virtualenvwrapper` installer by `export` in the terminal or put this in `~/.bashrc` file. Replcae the text `<absolute_path_to_virtualmachines>` with actual directory path.
    ```bash
    export LSCRIPTS__VMHOME="<absolute_path_to_virtualmachines>"
    export LSCRIPTS__PYVENV_PATH="${LSCRIPTS__VMHOME}/virtualenvs"
    ```
  * Execute the installer:
      ```bash
      lsd-install.python-virtualenvwrapper
      ```
6. Install CUDA stack (cuda, cudnn, tensorRT). supported CUDA: `9.0`, `10.0`, `10.2`, `11.0`.
    ```bash
    lsd-install.cuda-stack 10.0
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

## Configure Environment Variables

* Configure the environment variables for `python-virtualenvwrapper` installer by `export` in the terminal or put this in `~/.bashrc` file. Replcae the text `<absolute_path_to_virtualmachines>` with actual directory path.
  ```bash
  export LSCRIPTS__VMHOME="<absolute_path_to_virtualmachines>"
  export LSCRIPTS__PYVENV_PATH="${LSCRIPTS__VMHOME}/virtualenvs"
  ```

## Compelete List of Individual installer

* `lsd-install.<name_of_package>` is used to install individual software components. Here are currently available options:
    ```bash
    lsd-install.apache2
    lsd-install.atom-wget-dpkg
    lsd-install.audacity-apt
    lsd-install.balenaetcher-apt
    lsd-install.core-apt
    lsd-install.couchdb-apt
    lsd-install.cuda-stack
    lsd-install.darktable-apt
    lsd-install.diff-tools
    lsd-install.digikam-apt
    lsd-install.docker-ce
    lsd-install.docker-compose
    lsd-install.encryption-apt
    lsd-install.epub-editors-apt
    lsd-install.epub-readers-apt
    lsd-install.essentials-apt
    lsd-install.extras-apt
    lsd-install.ffmpeg-apt
    lsd-install.freecad-ppa
    lsd-install.gcc-apt
    lsd-install.ghostwriter-apt
    lsd-install.gimp-graphics-apt
    lsd-install.gitlab-apt
    lsd-install.golang
    lsd-install.handbrake-ppa
    lsd-install.haroopad-wget-dpkg
    lsd-install.heroku-cli-snap
    lsd-install.httrack-apt
    lsd-install.imagemagic-graphics-apt
    lsd-install.imageviewer-cmdline-apt
    lsd-install.inkscape-graphics-apt
    lsd-install.inotifytools-apt
    lsd-install.java-apt
    lsd-install.kafka-wget-dpkg
    lsd-install.kodi-multimedia-apt
    lsd-install.krita-ppa
    lsd-install.latex-apt
    lsd-install.latex-editors-apt
    lsd-install.librecad-ppa
    lsd-install.lyx-ppa
    lsd-install.makehuman3d-ppa
    lsd-install.mongodb-apt
    lsd-install.mysql-apt
    lsd-install.nginx-apt
    lsd-install.nodejs
    lsd-install.nvidia-container-toolkit
    lsd-install.nvidia-driver
    lsd-install.nvm
    lsd-install.obsstudio-ppa
    lsd-install.octave-apt
    lsd-install.openscad-ppa
    lsd-install.openshot-ppa
    lsd-install.openvpn-apt
    lsd-install.pandoc-wget-dpkg
    lsd-install.php
    lsd-install.pitvi-flatpak
    lsd-install.postgres-postgis-apt
    lsd-install.postman-testing-snap
    lsd-install.prerequisite
    lsd-install.prerequisite-opencv
    lsd-install.prerequisite-pcl
    lsd-install.pycharm-snap
    lsd-install.python
    lsd-install.python-virtualenvwrapper
    lsd-install.qgis3-apt
    lsd-install.rasdamandb-apt
    lsd-install.rclone
    lsd-install.redis-wget-make
    lsd-install.ros-apt
    lsd-install.ruby_rails_jekyll
    lsd-install.scribus-apt
    lsd-install.shotcut-wget
    lsd-install.shutter-ppa
    lsd-install.simplescreenrecorder-ppa
    lsd-install.slowmovideo-ppa
    lsd-install.stacer-apt
    lsd-install.sublime-apt
    lsd-install.sublimemerge-apt
    lsd-install.systemsensors-apt
    lsd-install.timeshift-apt
    lsd-install.typora-apt
    lsd-install.videofix-apt
    lsd-install.vim-apt
    lsd-install.vim-plug
    lsd-install.vlc-apt
    lsd-install.vokoscreen-ppa
    lsd-install.vulkansdk-apt
    lsd-install.wine-apt
    lsd-install.xnview-wget
    lsd-install.yarn
    lsd-install.youtubedl-apt
    lsd-install.zookeeper-wget
    ```
