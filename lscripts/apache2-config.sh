#!/bin/bash

## Copyright (c) 2024 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## Apache2 custom configuration
###----------------------------------------------------------


# trap ctrlc_handler INT

# ## trap 'exit 0' INT or simply trap INT 
# function ctrlc_handler {
#   (>&2 echo -e "\e[0;101m CTRL-C pressed; Terminating..!\e[0m\n")
#   exit
# }


function apache2_config() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${PHP_VER}" ]; then
    PHP_VER="7.2"
    echo "Unable to get PHP version, falling back to default version#: ${PHP_VER}"
  fi

  ## Enable Userdir Module
  sudo a2enmod userdir

  ## Enable ReWrite Engine Module
  sudo a2enmod rewrite

  ## Python with Apache

  ## disable multithreading processes
  sudo a2dismod mpm_event

  ## Enable cgi
  sudo a2enmod cgi
  sudo a2enmod mpm_prefork cgi

  ## Enable WSGI: mod_wsgi
  # sudo a2dismod wsgi
  sudo a2enmod wsgi

  ## configure as reverse proxy 
  sudo a2enmod proxy
  sudo a2enmod proxy_http


  [[ ! -d "${HOME}/public_html" ]] && (
    mkdir -p "${HOME}/public_html" && chmod 0755 "${HOME}/public_html"
  )

  PHP_INSTALLED_VER=`php --version | cut -d'-' -f1 | grep -i php | cut -d' ' -f2`

  echo -e "${biwhi} PHP_INSTALLED_VER: $PHP_INSTALLED_VER ${nocolor}"
  echo ""

  echo -e "${biwhi} Edit this file and make following entries: ${nocolor}"
  echo -e "${biyel} * (copy below line and replace the existing) ${nocolor}"
  echo -e "${biyel} * (use 'vi' editor only) ${nocolor}"
  echo ""
  echo -e "${icya} sudo vi /etc/apache2/mods-available/userdir.conf ${nocolor}"
  echo -e "${bired}"
cat << EOF
<IfModule mod_userdir.c>
  UserDir public_html
  UserDir disabled root


  #Solution using mod_headers and mod_setenvif
  <IfModule mod_headers.c>
     SetEnvIf Origin (.*) AccessControlAllowOrigin=$1
     Header add Access-Control-Allow-Origin %{AccessControlAllowOrigin}e env=AccessControlAllowOrigin
     Header set Access-Control-Allow-Credentials true
  </IfModule> 

  <Directory /home/*/public_html>
    #AllowOverride FileInfo AuthConfig Limit Indexes
    #Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    AllowOverride All
    Options MultiViews Indexes SymLinksIfOwnerMatch
    <Limit GET POST OPTIONS>
      # Apache <= 2.2:
      #Order allow,deny
      #Allow from all
 
      # Apache >= 2.4:
      Require all granted
    </Limit>
    <LimitExcept GET POST OPTIONS>
      # Apache <= 2.2:
      #Order deny,allow
      #Deny from all
 
      # Apache >= 2.4:
      Require all denied
    </LimitExcept>
  </Directory>
</IfModule>
EOF

  echo -e "${nocolor}"

  ## WSGIApplicationGroup %{GLOBAL}
  ## https://stackoverflow.com/questions/4236045/django-apache-mod-wsgi-hangs-on-importing-a-python-module-from-so-file
  ## https://www.pyimagesearch.com/2018/02/05/deep-learning-production-keras-redis-flask-apache/
  echo ""
  echo -e "${biwhi} Edit this file and make following entries: ${nocolor}"
  echo -e "${biyel} * (copy below line and replace the existing) ${nocolor}"
  echo -e "${biyel} * (use 'vi' editor only) ${nocolor}"
  echo ""
  echo -e "${icya} sudo vi /etc/apache2/mods-available/php${PHP_VER}.conf ${nocolor}"
  echo -e "${bired}"
cat << EOF
<IfModule mod_userdir.c>
    WSGIDaemonProcess wsgi-bin threads=10
    <Directory /home/*/public_html>
        #php_admin_flag engine Off
        AllowOverride All
    </Directory>
    <Directory /home/*/public_html/*/cgi-bin>
        DirectoryIndex index.py
        Options +ExecCGI
        SetHandler cgi-script
        AddHandler cgi-script .py 
    </Directory>
    <Directory /home/*/public_html/*/wsgi-bin>
        WSGIProcessGroup wsgi-bin
        WSGIApplicationGroup %{GLOBAL}
        DirectoryIndex index.wsgi    
        Options +ExecCGI
        SetHandler wsgi-script
        AddHandler wsgi-script .wsgi
    </Directory>
</IfModule>
EOF
  echo -e "${nocolor}"

  mkdir -p ${HOME}/public_html

  echo '<?php phpinfo(); ?>' > ${HOME}/public_html/info.php

  echo -e "${biwhi} Created file: ${HOME}/public_html/info.php ${nocolor}"
  echo ""
  echo -e "${biwhi} Restart the server:${nocolor}\n${icya} sudo service apache2 restart ${nocolor}"
  echo ""
  echo -e "${biwhi} Access server at: ${nocolor}\n${icya} http://localhost/~$USER/ ${nocolor}"
  echo -e "${biwhi} Access info.php at: ${nocolor}\n${icya} http://localhost/~$USER/info.php ${nocolor}"
  echo ""
}

apache2_config
