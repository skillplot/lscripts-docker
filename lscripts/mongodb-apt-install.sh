#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## MongoDB
###----------------------------------------------------------
#
## References:
## * https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-18-04
## * https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-mongodb-on-ubuntu-16-04#part-two-securing-mongodb
###----------------------------------------------------------


function mongodb-database-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  ## MongoDB configuration file
  # sudo nano /etc/mongodb.conf

  if [[ ${LINUX_ID} == 'Kali' ]]; then
    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list

    echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
    sudo apt -y update
    sudo apt -y install mongodb-org

    # ## To prevent unintended upgrades, you can pin the package at the currently installed version:
    # echo "mongodb-org hold" | sudo dpkg --set-selections
    # echo "mongodb-org-server hold" | sudo dpkg --set-selections
    # echo "mongodb-org-shell hold" | sudo dpkg --set-selections
    # echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
    # echo "mongodb-org-tools hold" | sudo dpkg --set-selections
  else
    ## Installing MongoDB
    # sudo apt -y update
    sudo apt -y install mongodb

    ## Checking the Service and Database
    sudo systemctl status mongodb

    ## Verify by connecting to the database server and executing a diagnostic command
    mongo --eval 'db.runCommand({ connectionStatus: 1 })'

    # ## Managing the MongoDB Service
    # sudo systemctl status mongodb
    # sudo systemctl stop mongodb
    # sudo systemctl start mongodb
    # sudo systemctl restart mongodb
    # sudo systemctl disable mongodb
    # sudo systemctl enable mongodb

    # ## Adjusting the Firewall (Optional)
    # # * To allow access to MongoDB on its default port 27017 from everywhere, you could use sudo ufw allow 27017. However, enabling internet access to MongoDB server on a default installation gives anyone unrestricted access to the database server and its data.

    # ## In most cases, MongoDB should be accessed only from certain trusted locations, such as another server hosting an application. To accomplish this task, you can allow access on MongoDB's default port while specifying the IP address of another server that will be explicitly allowed to connect:

    # sudo ufw allow from your_other_server_ip/32 to any port 27017  
    # sudo ufw status
  fi

}

mongodb-database-install.main "$@"
