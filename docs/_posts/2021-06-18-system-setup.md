---
layout: post
title:  "System Setup"
date:   2021-06-18 04:15:25 +0530
categories: system-setup
---


## Overview

Build and setup a system with required software utilities.

* **NOTE:**
  * Use of logger is mandatory; to invoke any of the scripts dependently
  * If cuda-stack is uninstalled, repo has to be added again when installing it again
  * Lower cuda version to be installed first; if you need multiple cuda installation; downgrades are not possible
  * When more then one cuda is installed; when prompted, should select yes to configure multiple-cuda in order to select the appropriate cuda being installed before verifying it
  * The sequencing of the installation is carefully crafted to build the full stack host system with maximum functionality from the compiled software suites
  * If utilities are already installed, **they will be upgraded** if latest packages are available.
* **Supported CUDA version per system**
  * ubuntu18.04: 9.0, 10.0, 10.2, 11.0
  * ubuntu16.04: 8.0, 9.0, 10.0
  * ubuntu14.04: 8.0, 10.0
  * It's possible to run different cuda versions on each Ubuntu OS, though it may have it's own quirks
* **Required Nvidia driver for different CUDA driver / runtime**
  * 10.0, 410+ driver
  * 10.2, 440+ driver
  * 11.0, 450+ driver


## Pre-requites

* Install and Configure Lscript - [quick-start](2021-05-08-quick-start.md)


## Additional Configurations
> Optional

* Configure the environment variables for `python-virtualenvwrapper` installer by `export` in the terminal or put this in `~/.bashrc` file. Replcae the text `<absolute_path_to_virtualmachines>` with actual directory path.
    ```bash
    export LSCRIPTS__VMHOME="<absolute_path_to_virtualmachines>"
    export LSCRIPTS__PYVENV_PATH="${LSCRIPTS__VMHOME}/virtualenvs"
    ```

## Software Stacks
> Quick Software Installation using software stacks

Software stacks are grouping of logical softwares based on their functionalities. Many softwares depends on each other and their are cyclic dependencies. The sequence of items installed using software stacks is done meticulously and it's recommended if you want to setup a complete multi-functional system stacks for development. These choice of packages are meant from development perspective and hence are not optimized for production installation. It's recommended to be prudent and observe the dependencies being installed or un-installed.


* List the all the different software installation stacks grouping
    ```bash
    lsd-stack.list
    ```
* To install individual software stack item
    ```bash
      lsd-stack.list <name_of_the_item>
    ```

## **a) Full-stack setup**

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


## **b) Item-wise setup**

This is **recommended** for first time setup and gives more control to select what will be installed.

* **Item-wise stack**
    ```bash
    lsd-stack.itemwise
    ```

## **c) Custom setup - chose whatever you want**

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
    lsd-install.ftp-apt
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
    lsd-install.vscode-apt
    lsd-install.vulkansdk-apt
    lsd-install.wine-apt
    lsd-install.xnview-wget
    lsd-install.yarn
    lsd-install.youtubedl-apt
    lsd-install.zookeeper-wget
    ```
