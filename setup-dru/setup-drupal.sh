#!/bin/bash

## Uses $CMS_PKG ENV var set in Dockerfile for install

if [[ -z "$APP_DB" ]] ; then
  echo '$APP_DB environmental variable not set in container'
  exit 1
elif [[ -z "$APP_USER" ]] ; then
  echo '$APP_USER environmental variable not set in container'
  exit 1
elif [[ -z "$APP_PASS" ]] ; then
  echo '$APP_PASS environmental variable not set in container'
  exit 1
elif [[ -z "$DB_PORT_3306_TCP_ADDR" ]] ; then
  echo '$DB_PORT_3306_TCP_ADDR environmental variable not set'
  echo 'Is this container linked with the database container as "db"?'
  exit 1
fi

DB_NAME=$APP_DB
DB_USER=$APP_USER
DB_PASS=$APP_PASS
DB_HOST=$DB_PORT_3306_TCP_ADDR
DB_URL="mysql://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"

if [[ $1 == "--shell" ]] ; then
  RUNSHELL='true'
fi

if [[ "$(/bin/ls -A /var/www/html)" ]] ; then
  /bin/echo "SOMETHING ALREADY INSTALLED IN '/var/www/html'"
  exit 1
else
  if [ ! -f "/var/www/html/sites/default/settings.php" ] ; then
    /bin/tar -xz -C /var/www/html --strip-components=1 -f /$CMS_PKG

    yes | /drush/drush site-install --db-url="$DB_URL" -r /var/www/html

    # UID 48 is Apache on RHEL-based servers
    # We can set UID 48 even if the user doesn't exist
    /bin/chown -R 48 /var/www/html
  fi
fi
if [[ $RUNSHELL == 'true' ]] ; then
  exec /bin/bash
fi
