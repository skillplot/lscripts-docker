#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Install Lscripts utilities and softwares
###----------------------------------------------------------
## References:
## https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
#
## Used in openCV:: doxygen doxygen-gui, graphviz
## For software builds:: cmake-curses-gui
## Admin system utils:: htop, apcalc
## cmd image viewer: feh
###----------------------------------------------------------


function essentials-apt-install.main() {
  ##sudo apt -y update
  sudo apt -y install -y --no-install-recommends \
    libcurl3-dev \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    aptitude \
    graphviz \
    openmpi-bin \
    rsync \
    unzip \
    zip \
    zlib1g-dev \
    git \
    swig \
    grep \
    feh \
    tree \
    sudo \
    libpng-dev \
    libjpeg-dev \
    libtool \
    bc \
    jq \
    openssh-client \
    openssh-server \
    apt-utils \
    gparted \
    net-tools \
    ppa-purge \
    sshfs \
    inxi \
    dos2unix \
    tree \
    exuberant-ctags \
    cmake-curses-gui

  # sudo apt -y install -y --no-install-recommends locales

  sudo apt -y install -y --no-install-recommends \
    uuid \
    automake \
    locate \
    unrar \
    mono-complete \
    chromium-browser \
    libimage-exiftool-perl \
    doxygen \
    doxygen-gui \
    libexif-dev \
    ntp \
    libconfig++-dev \
    kino \
    htop \
    apcalc

  ## For gnome Ubuntu >= 17
  sudo apt -y install -y --no-install-recommends \
    gnome-tweak-tool

  ## sudo apt install gnome-shell-extension-weather
  ## start gnome-tweaks by
  # gnome-tweaks

  sudo apt -y install -y --no-install-recommends \
    dconf-editor \
    openvpn \
    neofetch \
    libcanberra-gtk-module

  # sudo apt -y install -y --no-install-recommends \
  #   subversion

  [[ ${LINUX_ID} == 'Kali' ]] && (
    sudo apt -y install pepperflashplugin-nonfree
    sudo apt -y install libreoffice
    ## PDF viewer
    sudo apt -y install evince
    ## Enable network browser in Thunar File Browser
    sudo apt -y install gvfs-backends gvfs-bin gvfs-fuse
    ## Fix for: lsd-mod.log.error while loading shared libraries: libgconf-2.so.4: cannot open shared object file: No such file or directory
    sudo apt -y install libgconf-2-4
  )

  ## multiplexer
  # sudo apt install byobu
  # sudo apt install screen

  ## web based terminal
  # sudo apt install shellinabox

  ## * Enabe "New Document" Option
  ## https://linuxconfig.org/how-to-create-desktop-shortcut-launcher-on-ubuntu-18-04-bionic-beaver-linux
  touch "$HOME/Templates/Empty\ Document"
}

essentials-apt-install.main "$@"
