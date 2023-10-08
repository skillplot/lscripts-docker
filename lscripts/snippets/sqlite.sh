#!/bin/bash

# Update package list
sudo apt update

# Install SQLite3
sudo apt install sqlite3 sqlite3-doc

# Install Spatialite Extension
sudo apt install libsqlite3-mod-spatialite


#!/bin/bash

# Create a new SQLite database
sqlite3 myapp.db

# Set permissions for the database file
chmod 666 myapp.db


#!/bin/bash

# Install Apache web server
sudo apt install apache2

# Install PHP
sudo apt install php

# Download phpLiteAdmin
wget https://bitbucket.org/phpliteadmin/public/downloads/phpLiteAdmin_v1-9-8-2.zip
unzip phpLiteAdmin_v1-9-8-2.zip
mv phpLiteAdmin_v1-9-8-2 /var/www/html/phpliteadmin
