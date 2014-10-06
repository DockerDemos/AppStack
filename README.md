AppStack
========

Plug and Play application stacks with Docker

###DATA###

Creates a container to store and access persistent data.

`docker run -d -v /tmp/dataonly/web:/var/www/html -v /tmp/dataonly/mysql:/var/lib/mysql \
       -v /tmp/dataonly/logs:/var/log -v /tmp/dataonly/backup:/var/backup \
	          -v /conf --name data data "my application stack"`

###SETUP-MYSQL###

Pre-configures MySQL \(MariaDB\) for the MySQL container.

`docker run -it --rm=true --volumes-from data -e ROOT_PASS=$DB_ROOT_PW \
            -e "APP_DB=$APP_DB" -e "APP_USER=$APP_USER" -e "APP_PASS=$APP_PASS" \
            -e BACKUP_PASS=$DB_BACKUP_PW setup-mysql`

...where `$APP_DB` is what you want the database to be named, `$APP_SER` is the username you want for your application, `$APP_PASS` is the password for that user, and `$DB_BACKUP_PW` is the password for a "backup" user that can connect from the backup container (below) to do a database backup for you.

###MYSQL###

MySQL \(MariaDB\) container.

`docker run -d -P --volumes-from data --name db mysql`

###SETUP-WP###

Pre-configures WordPress, if desired.

`docker tag setup-wp:MY_WORDPRESS_VERSION  setup-wp:latest`

`docker run -it --rm=true --volumes-from data -e ROOT_PASS=$DB_ROOT_PW \
            -e "APP_DB=$APP_DB" -e "APP_USER=$APP_USER" -e "APP_PASS=$APP_PASS" \
	    setup-wp:latest`

...with the same database name, user name and password as above.

###SETUP-DRU###

Similar to above: Pre-configures Drupal, if desired.

`docker tag setup-dru:MY_DRUPAL_VERSION  setup-dru:latest`

`docker run -it --rm=true --volumes-from data -e ROOT_PASS=$DB_ROOT_PW \
            -e "APP_DB=$APP_DB" -e "APP_USER=$APP_USER" -e "APP_PASS=$APP_PASS" \
	    setup-dru:latest`

...same deal with the db, user and password.

###APACHE###

Apache webserver container with REQUIRED SSL setup.

`docker run -d -P -e "SSLKEY=$(cat MYSSLKEY.key)" -e "SSLCRT=$(cat MYSSLCERT.crt)" -e "CACERT=$(cat MYCACERT.crt)" --volumes-from data --name web apache`

`CACERT` is optional.  Add this if you need a Certificate Authority certificate or intermediate certificate to complete your SSL certificate chain.

###BACKUP###

Container for connecting to the database contaner and performing database backups.

`docker run -it --rm=true --volumes-from data -e "BACKUP_PASS=MY_BACKUP_PASS" --name backup --link db:db backup`

##Copyright Information##

Copyright (C) 2014 Chris Collins

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
