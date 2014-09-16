AppStack
========

Plug and Play application stacks with Docker


* docker run -d -v /tmp/dataonly/web:/var/www/html -v /tmp/dataonly/mysql:/var/lib/mysql -v /tmp/dataonly/logs:/var/log --name data dataonly "<APPLICATION NAME>"
* docker  run -d --volumes-from data mysql /usr/bin/mysqld_safe
* docker run -it -e DB=MYSQL -e CMS=DRUPAL -e CMSVER=7.31 --volumes-from data setup /build-scripts/setup.sh
