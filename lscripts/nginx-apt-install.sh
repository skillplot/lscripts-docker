#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## nginx
###----------------------------------------------------------


function nginx-apt-install.main() {
  # sudo apt -y update
  sudo apt -y install nginx
  sudo ufw app list
  sudo ufw allow 'Nginx HTTP'
  sudo ufw status
  sudo systemctl status nginx.service

  ## This will _log_.fail if apache is running, as nginx by defaults binds to port 80
  # sudo systemctl stop apache2.service
  # sudo systemctl start nginx
}

nginx-apt-install.main