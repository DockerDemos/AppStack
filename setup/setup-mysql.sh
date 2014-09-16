#!/bin/sh

datadir='/var/lib/mysql'
logdir='/var/log'
socketfile="$datadir/mysql.sock"
errlogfile="$logdir/mysqld-error.log"
slologfile="$logdir/mysqld-slow.log"
genlogfile="$logdir/mysqld-general.log"
mypidfile='/var/run/mysqld/mysqld.pid'

if [[ ! -f "$errlogfile" ]] ; then
  touch "$errlogfile" 2>/dev/null
  touch "$slologfile" 2>/dev/null
  touch "$genlogfile" 2>/dev/null
fi

chown mysql:mysql "$errlogfile" "$slologfile" "$genlogfile"
chmod 0640 "$errlogfile" "$slologfile" "$genlogfile"

chown mysql:mysql "$datadir"
chmod 0755 "$datadir"
/usr/bin/mysql_install_db --datadir="$datadir" --user=mysql
chmod 0755 "$datadir"

chown -R mysql:mysql "$datadir"
chmod 0755 "$datadir"

