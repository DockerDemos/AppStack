#!/bin/sh

if [[ -z "$APP_DB" ]] ; then
  echo '$APP_DB environmental variable not set in container'
  exit 1
elif [[ -z "$APP_USER" ]] ; then
  echo '$APP_USER environmental variable not set in container'
  exit 1
elif [[ -z "$APP_PASS" ]] ; then
  echo '$APP_PASS environmental variable not set in container'
  exit 1
fi

DB_NAME=$APP_DB
DB_USER=$APP_USER
DB_PASS=$APP_PASS

if [[ $1 == "--shell" ]] ; then
  RUNSHELL='true'
fi

f_help() {
  echo -e "
  Acceptable arguments are:
    --help  - Print this message
    --debug - Print envars to the screen \n"
  exit 1
}

f_debug() {

  echo "Environment Variables"
  env
  echo ""
  exit 1
}

if [[ $1 == "--debug" ]] ; then
  f_debug
elif [[ $1 == "--help" ]] ; then
  f_help
elif [[ ! -z $1 ]] ; then
  echo -e "
  Unknown argument."
  f_help
fi


if [[ -z $ROOT_PASS ]] ; then
  echo "NO ROOT USER PASSWORD SPECIFIED"
  exit 1
fi

if [[ -z $BACKUP_PASS ]] ; then
  echo "NO BACKUP USER PASSWORD SPECIFIED"
  exit 1
fi

datadir='/var/lib/mysql'
socketfile="$datadir/mysql.sock"
logdir='/var/log/mariadb'
logfile="$logdir/mariadb.log"
errlogfile="$logdir/mariadb-error.log"
slologfile="$logdir/mariadb-slow.log"
  
if [ ! -f "$datadir/ibdata1" ] ; then

  mkdir -p $logdir/mariadb	

  touch "$errlogfile" 2>/dev/null
  touch "$slologfile" 2>/dev/null
  touch "$logfile" 2>/dev/null

  chown mysql:mysql "$errlogfile" "$slologfile" "$logfile"
  chmod 0640 "$errlogfile" "$slologfile" "$logfile"
  
  /usr/bin/mysql_install_db --datadir="$datadir" --user=mysql
  
  chown -R mysql:mysql "$datadir"
  chmod 0755 "$datadir"

  /usr/bin/mysqld_safe &
  sleep 5s

  mysql -u root -e "CREATE DATABASE $DB_NAME ; GRANT ALL PRIVILEGES on $DB_NAME.* to \"$DB_USER\"@'%' IDENTIFIED BY \"$DB_PASS\";"
  mysql -u root -e "GRANT ALL PRIVILEGES on *.* to 'backup'@'%' IDENTIFIED BY \"$BACKUP_PASS\";"
  # MAKE SURE THIS ONE IS LAST, OR WE'LL HAVE TO PASS THE ROOT PW EVERY TIME
  mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD(\"$ROOT_PASS\") WHERE User='root'; FLUSH PRIVILEGES"

fi

if [[ $RUNSHELL == 'true' ]] ; then
  exec /bin/bash
fi

