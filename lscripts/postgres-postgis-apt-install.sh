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

# Note that you can only create new superuser roles if you are creating them as a role that is already a superuser. By default, the postgres role is a superuser.
# Another assumption that the Postgres authentication system makes by default is that for any role used to log in, that role will have a database with the same name which it can access.
## * https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04
## * https://digitalocean.com/community/articles/how-to-create-remove-manage-tables-in-postgresql-on-a-cloud-server
## Note that in SQL, every statement must end in a semicolon (;).




function postgres-postgis-apt-install.cmds() {
  sudo -i -u postgres
  psql
  sudo -u postgres psql

  createuser --interactive
  sudo -u postgres createuser --interactive

  createdb sammy
  sudo -u postgres createdb sammy

  sudo adduser sammy
  sudo -i -u sammy
  psql
  ## or
  sudo -u sammy psql

  \conninfo
  \q
  \dt

  # CREATE TABLE playground (
  #     equip_id serial PRIMARY KEY,
  #     type varchar (50) NOT NULL,
  #     color varchar (25) NOT NULL,
  #     location varchar(25) check (location in ('north', 'south', 'west', 'east', 'northeast', 'southeast', 'southwest', 'northwest')),
  #     install_date date
  # );

  # INSERT INTO playground (type, color, location, install_date) VALUES ('slide', 'blue', 'south', '2017-04-28');
  # INSERT INTO playground (type, color, location, install_date) VALUES ('swing', 'yellow', 'northwest', '2018-08-16');

  # SELECT * FROM playground;
}


function postgres-postgis-apt-install.main() {
  ## sudo apt -y install python-pip python-dev
  sudo apt -y install libpq-dev postgresql postgresql-contrib pgadmin3
  sudo apt -y install postgis
  sudo apt -y install postgresql-server-dev-all
}

postgres-postgis-apt-install.main "$@"
