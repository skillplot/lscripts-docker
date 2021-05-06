#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## PostgresSQL
###----------------------------------------------------------
#
## References:
## * http://www.gis-blog.com/how-to-install-postgis-2-3-on-ubuntu-16-04-lts/
## * https://packages.ubuntu.com/xenial/postgresql-server-dev-9.5
###----------------------------------------------------------


## sudo apt -y install python-pip python-dev
sudo apt -y install libpq-dev postgresql postgresql-contrib pgadmin3
sudo apt -y install postgis
sudo apt -y install postgresql-server-dev-all
