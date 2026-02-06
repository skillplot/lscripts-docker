---
title: [Legacy] Tools Stack
date: "2021-07-04 09:00:00 +0530"
categories:
  - Archive
  - Lscripts-docker
tags:
  - Tools
  - legacy
  - lscripts-docker
toc: true
---
{: .prompt-warning }
This is an **archived** post migrated from the previous minima-based site. It may describe older workflows or legacy setups.

## [0]: prerequisite

* prerequisite
* prerequisite-pcl
* prerequisite-opencv


## [1]: nvidia_cuda_python_docker

* nvidia-driver
* docker-ce
* docker-compose
* nvidia-container-toolkit
* python
* python-virtualenvwrapper
* cuda-stack


## [2]: utils

* core-apt
* essentials-apt
* extras-apt
* diff-tools
* encryption-apt


### Core Packages

### Essential Packages

1. first set
    ```bash
    libfreetype6-dev
    libhdf5-serial-dev
    libzmq3-dev
    pkg-config
    aptitude
    graphviz
    openmpi-bin
    rsync
    unzip
    zip
    zlib1g-dev
    git
    swig
    grep
    feh
    tree
    sudo
    libpng-dev
    libjpeg-dev
    libtool
    bc
    jq
    openssh-client
    openssh-server
    apt-utils
    gparted
    net-tools
    ppa-purge
    sshfs
    inxi
    dos2unix
    tree
    exuberant-ctags
    cmake-curses-gui
    ```
2. Second set
    ```bash
    uuid
    automake
    locate
    unrar
    mono-complete
    chromium-browser
    libimage-exiftool-perl
    doxygen
    doxygen-gui
    libexif-dev
    ntp
    libconfig++-dev
    kino
    htop
    apcalc
    xclip
    xsel
    ```
3. Third set
    ```bash
    dconf-editor
    openvpn
    neofetch
    libcanberra-gtk-module
    ```

#### Package Details

* `jq` - JSON command line parser
* `yamllint` - YAML command line parser and validator -



## [3]: sysutils

* rclone
* inotifytools-apt
* stacer-apt
* systemsensors-apt
* timeshift-apt
* ftp-apt


## [4]: editors

* vim-apt
* vim-plug
* sublime-apt
* atom-wget-dpkg
* vscode-apt


## [5]: markdowneditors

* haroopad-wget-dpkg
* typora-apt
* ghostwriter-apt


## [6]: python_stack

* python
* python-virtualenvwrapper


## [7]: docker_stack

* docker-ce
* docker-compose


## [8]: programming

* java-apt
* php
* apache2
* nginx-apt
* nvm
* nodejs
* yarn
* golang
* octave-apt
* ruby_rails_jekyll
* gcc-apt
* postman-testing-snap


## [9]: epub

* latex-apt
* pandoc-wget-dpkg
* latex-editors-apt
* lyx-ppa
* epub-editors-apt
* epub-readers-apt
* scribus-apt


## [10]: storage

* redis-wget-make
* postgres-postgis-apt
* mysql-apt
* mongodb-apt
* couchdb-apt
* rasdamandb-apt
* zookeeper-wget
* kafka-wget-dpkg


## [11]: multimedia

* vlc-apt
* ffmpeg-apt
* videofix-apt
* obsstudio-ppa
* slowmovideo-ppa
* youtubedl-apt
* inkscape-graphics-apt
* imageviewer-cmdline-apt
* imagemagic-graphics-apt
* gimp-graphics-apt
* krita-ppa
* digikam-apt
* darktable-apt
* xnview-wget
* shutter-ppa
* simplescreenrecorder-ppa
* vokoscreen-ppa
* handbrake-ppa
* pitvi-flatpak
* openshot-ppa
* shotcut-wget
* kodi-multimedia-apt
* audacity-apt
* freecad-ppa
* librecad-ppa
* openscad-ppa
* makehuman3d-ppa


## [12]: misc

* balenaetcher-apt
* httrack-apt
* heroku-cli-snap
* openvpn-apt
* gitlab-apt
* sublimemerge-apt
* ros-apt
* vulkansdk-apt
* wine-apt
* pycharm-snap
* qgis3-apt
