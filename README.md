AppStack
========

Plug and Play application stacks with Docker

DATA
----

docker run -d -v /tmp/dataonly/web:/var/www/html -v /tmp/dataonly/mysql:/var/lib/mysql -v /tmp/dataonly/logs:/var/log -v /tmp/dataonly/backup:/var/backup -v /conf --name data dataonly "test"

SETUP-MYSQL
-----------

docker run -it --rm=true --volumes-from data -e "ROOT_PASS=MY_ROOT_PW" -e "BACKUP_PASS=MY_BACKUP_PW" setup-mysql

SETUP-WP
--------

docker run -it --rm=true --volumes-from data setup-wp:latest

MYSQL
-----

docker run -d -P --volumes-from data --name db mysql

APACHE
------

docker run -d -P --volumes-from data --name web apache

BACKUP
------
docker run -it --rm=true --volumes-from data -e "BACKUP_PASS=MY_BACKUP_PASS" --name backup --link db:db backup

