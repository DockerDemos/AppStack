AppStack
========

Plug and Play application stacks with Docker

DATACONTAINER
-------------

docker run -d -v /tmp/dataonly/web:/var/www/html -v /tmp/dataonly/mysql:/var/lib/mysql -v /tmp/dataonly/logs:/var/log -v /tmp/dataonly/backup:/var/backup -v /conf --name data dataonly "test"

SETUP-MYSQL
-----------

docker run -it --rm=true --volumes-from data -e "ROOT_PASS=TIMRPYB" -e "BACKUP_PASS=TIMBPYB" setup-mysql

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
docker run -it --rm=true --volumes-from data --name backup --link db:db backup

