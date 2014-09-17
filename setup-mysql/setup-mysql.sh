#!/bin/sh

ARG="$1"

if [ "$ARG" = '--help' ] ; then
  # Some help text here maybe
  true
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

  mysql -u root -e "GRANT ALL PRIVILEGES on *.* to 'backup'@'%' IDENTIFIED BY \"$BACKUP_PASS\";"
  mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD(\"$ROOT_PASS\") WHERE User='root'; FLUSH PRIVILEGES"

fi
