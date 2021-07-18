#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
##----------------------------------------------------------
## software stack installation configuration
##----------------------------------------------------------


declare -a _stack_install_itemwise=(
  ###----------------------------------------------------------    
  ## "_stack-setup-prerequisite"
  ###----------------------------------------------------------    
  # "prerequisite_lite"
  "prerequisite"
  "prerequisite-pcl"
  "prerequisite-opencv"
  ###----------------------------------------------------------
  ## "_stack-setup-nvidia-cuda-python-docker"
  ###----------------------------------------------------------
  "nvidia-driver"
  "docker-ce"
  "docker-compose"
  "nvidia-container-toolkit"
  "python"
  "python-virtualenvwrapper"
  "cuda-stack"
  ###----------------------------------------------------------
  ## "_stack-setup-utils"
  ###----------------------------------------------------------
  "core-apt"
  "extras-apt"
  "essentials-apt"
  "diff-tools"
  "encryption-apt"
  ###----------------------------------------------------------    
  ## "_stack-setup-sysutils"
  ###----------------------------------------------------------    
  "rclone"
  "inotifytools-apt"
  "stacer-apt"
  "systemsensors-apt"
  "timeshift-apt"
  "ftp-apt"
  ###----------------------------------------------------------    
  ## "_stack-setup-editors"
  ###----------------------------------------------------------
  "vim-apt"
  "vim-plug"
  "sublime-apt"
  "vscode-apt"
  "atom-wget-dpkg"
  ###----------------------------------------------------------    
  ## "_stack-setup-markdown"
  ###----------------------------------------------------------
  "haroopad-wget-dpkg"
  "typora-apt"
  "ghostwriter-apt"
  ###----------------------------------------------------------    
  ## "_stack-setup-programming"
  ###----------------------------------------------------------
  "java-apt"
  "php"
  "apache2"
  "nginx-apt"
  "nvm"
  "nodejs"
  "yarn-apt"
  "golang"
  "octave-apt"
  "postman-testing-snap"
  "ruby_rails_jekyll"
  "gcc-apt"
  ###----------------------------------------------------------    
  ## "_stack-setup-epub"
  ###----------------------------------------------------------
  "latex-apt"
  "pandoc-wget-dpkg"
  "latex-editors-apt"
  "lyx-ppa"
  "epub-editors-apt"
  "epub-readers-apt"
  "scribus-apt"
  ###----------------------------------------------------------    
  ## "_stack-setup-storage"
  ###----------------------------------------------------------
  "redis-wget-make"
  "postgres-postgis-apt"
  "mysql-apt"
  "mongodb-apt"
  "couchdb-apt"
  # "elasticsearch"
  "rasdamandb-apt"
  "zookeeper-wget"
  "kafka-wget-dpkg"
  ###----------------------------------------------------------    
  ## "_stack-setup-graphics"
  ###----------------------------------------------------------
  "vlc-apt"
  "ffmpeg-apt"
  "videofix-apt"
  "obsstudio-ppa"
  "slowmovideo-ppa"
  "youtubedl-apt"
  ###----------------------------------------------------------
  ## "image editors"
  ###----------------------------------------------------------
  "inkscape-graphics-apt"
  "imageviewer-cmdline-apt"
  "imagemagic-graphics-apt"
  "gimp-graphics-apt"
  "krita-ppa"
  "digikam-apt"
  "darktable-apt"
  "xnview-wget"
  ###----------------------------------------------------------
  ## "screenshot, screen-recorders"
  ###----------------------------------------------------------
  "shutter-ppa"
  "simplescreenrecorder-ppa"
  "vokoscreen-ppa"
  ###----------------------------------------------------------
  ## "video editors"
  ###----------------------------------------------------------
  "handbrake-ppa"
  "pitvi-flatpak"
  "openshot-ppa"
  "shotcut-wget"
  ###----------------------------------------------------------
  ## "home theater"
  ###----------------------------------------------------------
  "kodi-multimedia-apt"
  ###----------------------------------------------------------
  ## "audio editors"
  ###----------------------------------------------------------
  "audacity-apt"
  ###----------------------------------------------------------    
  ## "cad, 3D tools"
  ###----------------------------------------------------------
  "freecad-ppa"
  "librecad-ppa"
  "openscad-ppa"
  "makehuman3d-ppa"
  ###----------------------------------------------------------    
  ## "_stack-setup-misc"
  ###----------------------------------------------------------
  "balenaetcher-apt"
  "httrack-apt"
  "heroku-cli-snap"
  "openvpn-apt"
  "gitlab-apt"
  "sublimemerge-apt"
  "ros-apt"
  "vulkansdk-apt"
  "wine-apt"
  ###----------------------------------------------------------    
  ## "IDEs"
  ###----------------------------------------------------------
  "pycharm-snap"
  ###----------------------------------------------------------    
  ## "GIS"
  ###----------------------------------------------------------
  "qgis3-apt"
  ###----------------------------------------------------------    
  ## "virtualization"
  ###----------------------------------------------------------
  "virtualbox-apt"
)

## _stack-setup-all
declare -a _stack_install_items=(
  "prerequisite"
  "nvidia_cuda_python_docker"
  "utils"
  "sysutils"
  "editors"
  "markdowneditors"
  "python_stack"
  "docker_stack"
  "programming"
  "epub"
  "storage"
  "multimedia"
  "misc"
)


## _stack-setup-prerequisite
declare -a _stack_install_prerequisite=(
  "prerequisite"
  "prerequisite-pcl"
  "prerequisite-opencv"
)


## _stack_install_python_stack
declare -a _stack_install_python_stack=(
  ###----------------------------------------------------------
  ## _stack_install_python_stack
  ###---------------------------------------------------------- 
  "python"
  "python-virtualenvwrapper"
)

## _stack_install_nvidia_cuda_python_docker
declare -a _stack_install_nvidia_cuda_python_docker=(
  ###----------------------------------------------------------
  ## _stack_install_nvidia_cuda_python_docker
  ###---------------------------------------------------------- 
  "nvidia-driver"
  "docker-ce"
  "docker-compose"
  "nvidia-container-toolkit"
  "python"
  "python-virtualenvwrapper"
  "cuda-stack"
)

declare -a _stack_verify_nvidia_cuda_python_docker=(
  "docker-ce"
  "docker-compose"
  "cuda-stack"
)

declare -a _stack_install_utils=(
  ###----------------------------------------------------------
  ## _stack-setup-utils
  ###---------------------------------------------------------- 
  "core-apt"
  "essentials-apt"
  "extras-apt"
  "diff-tools"
  "encryption-apt"
)

declare -a _stack_install_sysutils=(
  ###----------------------------------------------------------
  ## _stack-setup-sysutils
  ###---------------------------------------------------------- 
  "rclone"
  "inotifytools-apt"
  "stacer-apt"
  "systemsensors-apt"
  "timeshift-apt"
  "ftp-apt"
)

## _stack-setup-editors
declare -a _stack_install_editors=(
  ###----------------------------------------------------------    
  ## "_stack-setup-editors"
  ###----------------------------------------------------------
  "vim-apt"
  "vim-plug"
  "sublime-apt"
  "atom-wget-dpkg"
  "vscode-apt"
)

declare -a _stack_install_markdowneditors=(
  ###----------------------------------------------------------    
  ## "_stack-setup-markdown"
  ###----------------------------------------------------------
  "haroopad-wget-dpkg"
  "typora-apt"
  "ghostwriter-apt"
)

## _stack-setup-docker
declare -a _stack_install_docker_stack=(
  "docker-ce"
  "docker-compose"
)


declare -a _stack_verify_docker_stack=(
  "docker-ce"
  "docker-compose"
)


## _stack-setup-programming
declare -a _stack_install_programming=(
  "java-apt"
  "php"
  "apache2"
  "nginx-apt"
  "nvm"
  "nodejs"
  "yarn"
  "golang"
  "octave-apt"
  "ruby_rails_jekyll"
  "gcc-apt"
  "postman-testing-snap"
)


declare -a _stack_install_epub=(
  ###----------------------------------------------------------    
  ## "_stack-setup-epub"
  ###----------------------------------------------------------
  "latex-apt"
  "pandoc-wget-dpkg"
  "latex-editors-apt"
  "lyx-ppa"
  "epub-editors-apt"
  "epub-readers-apt"
  "scribus-apt"
)


declare -a _stack_install_storage=(
  ###----------------------------------------------------------
  ## _stack-setup-storage
  ###----------------------------------------------------------
  "redis-wget-make"
  "postgres-postgis-apt"
  "mysql-apt"
  "mongodb-apt"
  "couchdb-apt"
  # "elasticsearch"
  "rasdamandb-apt"
  "zookeeper-wget"
  "kafka-wget-dpkg"
)


declare -a _stack_install_multimedia=(
  ###----------------------------------------------------------    
  ## "_stack-setup-multimedia"
  ###----------------------------------------------------------
  "vlc-apt"
  "ffmpeg-apt"
  "videofix-apt"
  "obsstudio-ppa"
  "slowmovideo-ppa"
  "youtubedl-apt"
  ###----------------------------------------------------------
  ## "image editors"
  ###----------------------------------------------------------
  "inkscape-graphics-apt"
  "imageviewer-cmdline-apt"
  "imagemagic-graphics-apt"
  "gimp-graphics-apt"
  "krita-ppa"
  "digikam-apt"
  "darktable-apt"
  "xnview-wget"
  ###----------------------------------------------------------
  ## "screenshot, screen-recorders"
  ###----------------------------------------------------------
  "shutter-ppa"
  "simplescreenrecorder-ppa"
  "vokoscreen-ppa"
  ###----------------------------------------------------------
  ## "video editors"
  ###----------------------------------------------------------
  "handbrake-ppa"
  "pitvi-flatpak"
  "openshot-ppa"
  "shotcut-wget"
  ###----------------------------------------------------------
  ## "home theater"
  ###----------------------------------------------------------
  "kodi-multimedia-apt"
  ###----------------------------------------------------------
  ## "audio editors"
  ###----------------------------------------------------------
  "audacity-apt"
  ###----------------------------------------------------------    
  ## "cad, 3D tools"
  ###----------------------------------------------------------
  "freecad-ppa"
  "librecad-ppa"
  "openscad-ppa"
  "makehuman3d-ppa"
)


declare -a _stack_install_misc=(
  ###----------------------------------------------------------    
  ## "_stack-setup-misc"
  ###----------------------------------------------------------
  "balenaetcher-apt"
  "httrack-apt"
  "heroku-cli-snap"
  "openvpn-apt"
  "gitlab-apt"
  "sublimemerge-apt"
  "ros-apt"
  "vulkansdk-apt"
  "wine-apt"
  ###----------------------------------------------------------    
  ## "IDEs"
  ###----------------------------------------------------------
  "pycharm-snap"
  ###----------------------------------------------------------    
  ## "GIS"
  ###----------------------------------------------------------
  "qgis3-apt"
  ###----------------------------------------------------------    
  ## "virtualization"
  ###----------------------------------------------------------
  "virtualbox-apt"
)
