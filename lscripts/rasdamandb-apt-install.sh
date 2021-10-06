#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Rasdaman
## Rasdaman is an Array DBMS, that is: a Database Management System which adds capabilities
## for storage and retrieval of massive multi-dimensional arrays, such as sensor, image, and statistics data.
###----------------------------------------------------------
#
## References:
## * http://www.rasdaman.org/wiki/InstallFromDEB
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function rasdamandb-addrepo() {
  sudo apt -y update

  local RASDAMAN_KEY_URL="http://download.rasdaman.org/packages/rasdaman.gpg"
  lsd-mod.log.debug "RASDAMAN_KEY_URL: ${RASDAMAN_KEY_URL}"


  ## Import the rasdaman repository public key to the apt keychain:
  # wget -O - http://download.rasdaman.org/packages/rasdaman.gpg | sudo apt-key add -

  # wget -O - ${RASDAMAN_KEY_URL} | sudo apt-key add -

  ## Add Rasdaman’s official GPG key
  curl -fsSL "${RASDAMAN_KEY_URL}" | sudo apt-key add -

  ## Verify that you now have the key with the fingerprint:
  ## by searching for the last 8 characters of the fingerprint.
  # sudo apt-key fingerprint ${RASDAMAN_REPO_KEY}

  # Add the rasdaman repository to apt.
  ## stable

  local RASDAMAN_REPO_URL="http://download.rasdaman.org/packages/deb"

  ###----------------------------------------------------------
  ## For ubuntu 16.04
  ###----------------------------------------------------------
  # echo "deb [arch=amd64] http://download.rasdaman.org/packages/deb xenial stable" \
  #   | sudo tee /etc/apt/sources.list.d/rasdaman.list

  ###----------------------------------------------------------
  ## For ubuntu 18.04
  ###----------------------------------------------------------
  # echo "deb [arch=amd64] http://download.rasdaman.org/packages/deb bionic stable" \
  #   | sudo tee /etc/apt/sources.list.d/rasdaman.list

  # echo "deb [arch=amd64] ${RASDAMAN_REPO_URL} $(lsb_release -sc) stable"  | sudo tee /etc/apt/sources.list.d/rasdaman.list

  ## Use the following command to set up the stable repository.
  ## You always need the stable repository, even if you want to install
  ## builds from the edge or test repositories as well.
  sudo add-apt-repository \
     "deb [arch=amd64] ${RASDAMAN_REPO_URL} \
     $(lsb_release -sc) \
     stable"

  sudo apt -y update

  ## List the versions available in your repo

}


function __rasdamandb-install() {
  sudo apt -y install rasdaman
  source /etc/profile.d/rasdaman.sh

  # Update
  # sudo apt-get update
  # sudo apt-get install rasdaman
  # sudo migrate_petascopedb.sh

  # # Administration
  # sudo service rasdaman start
  # sudo service rasdaman stop
  # sudo service rasdaman status

  ###----------------------------------------------------------
  ## Review the installation settings:
  ###----------------------------------------------------------

  # Install path: /opt/rasdaman/
  # User: rasdaman
  # Database: sqlite, /opt/rasdaman/data/
  # Install webapps: True
  #   Petascopedb url: jdbc:postgresql://localhost:5432/petascopedb
  #   Petascopedb user: petauser
  #   Deployment: external
  #   Webapps path: /var/lib/tomcat8/webapps
  #   Webapps logs: /var/log/tomcat8
  # Insert demos: True

  # Rasdaman installed and configured successfully.
  # Next steps
  #  * Make sure that rasql is on the PATH first:
  #    $ source /etc/profile.d/rasdaman.sh
  #  * Then try some rasql queries using the rasql CLI, e.g:
  #    $ rasql -q 'select encode( mr, "png" ) from mr' --out file
  #  * Try the WCS client in your browser at http://localhost:8080/rasdaman/ows


  # More information can be found at http://rasdaman.org. Have fun!
  # To add rasdaman to the PATH: source /etc/profile.d/rasdaman.sh
  # Processing triggers for libc-bin (2.27-3ubuntu1) ...
  # Processing triggers for systemd (237-3ubuntu10.3) ...
  # Processing triggers for ureadahead (0.100.0-20) ...

  ## https://www.revolvermaps.com/livestats/globe/a1850emr3y9/

  # https://doc.rasdaman.org/02_inst-guide.html#sec-system-install-installer-config
  # https://doc.rasdaman.org/02_inst-guide.html#sec-system-initialize-rasdaman

  ## did not work
  # export RASDATA=/boozo-dat/databases/rasdaman

  # mkdir -p /boozo-dat/databases/rasdaman/data
  # sudo ln -s /boozo-dat/databases/rasdaman/data /opt/rasdaman/data
  # sudo chown -R $(id -u):$(id -g) /opt/rasdaman/data

  # mkdir -p /boozo-dat/databases/rasdaman/log
  # sudo ln -s /boozo-dat/databases/rasdaman/log /opt/rasdaman/log
  # sudo chown -R $(id -u):$(id -g) /opt/rasdaman/log

  # export RMANHOME=/opt/rasdaman
  # export PATH=$RMANHOME/bin:$PATH
  
  # create_db.sh

  # rasdaman_insertdemo.sh localhost 7001  $RMANHOME/share/rasdaman/examples/images rasadmin rasadmin
  # rasql -q "select r from RAS_COLLECTIONNAMES as r"  --out string
}


function rasdamandb-install.main() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh
  
  local scriptname=$(basename ${BASH_SOURCE[0]})
  lsd-mod.log.debug "executing script...: ${scriptname}"

  local _prog="rasdamandb"

  lsd-mod.log.info "Install ${_prog}..."
  lsd-mod.log.warn "sudo access is required!"

  local _default=no
  local _que
  local _msg


  _que="Add ${_prog} repo"
  _msg="Skipping adding ${_prog} repo!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Adding ${_prog} repo..." && \
      ${_prog}-addrepo \
    || lsd-mod.log.echo "${_msg}"


  _que="Install ${_prog} now"
  _msg="Skipping ${_prog} installation!"
  lsd-mod.fio.yesno_${_default} "${_que}" && \
      lsd-mod.log.echo "Installing..." && \
      __${_prog}-install \
    || lsd-mod.log.echo "${_msg}"

}


rasdamandb-install.main "$@"
