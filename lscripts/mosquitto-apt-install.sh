#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## mosquitto
###----------------------------------------------------------
#
## References:
## * https://www.instructables.com/How-to-Use-MQTT-With-the-Raspberry-Pi-and-ESP8266/
###----------------------------------------------------------


function mosquitto-configure() {
  echo 'todo'
  # sudo vi /etc/mosquitto/mosquitto.conf

  # sudo service mosquitto start

  # * Delete this line.
  #     ```bash
  #     include_dir /etc/mosquitto/conf.d
  #     ```
  # * Add the following lines to the bottom of the file.
  #     ```bash
  #     allow_anonymous false
  #     password_file /etc/mosquitto/pwfile
  #     listener 1883
  #     ```

  # sudo mosquitto_passwd -c /etc/mosquitto/pwfile <username>
}

function mosquitto-install.main() {
  sudo apt -y update
  sudo apt -y install mosquitto
  sudo apt -y install mosquitto-clients
}

mosquitto-install.main "$@"
