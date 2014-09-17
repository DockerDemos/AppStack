#!/bin/sh

if [[ -z $ROOT_PASS ]] ; then 
  echo "NO ROOT USER PASSWORD SPECIFIED"
  exit 1
fi

if [[ -z $BACKUP_PASS ]] ; then 
  echo "NO BACKUP USER PASSWORD SPECIFIED"
  exit 1
fi

mysql='/usr/bin/mysqld_safe'
datadir='/var/lib/mysql'
socketfile="$datadir/mysql.sock"
errlogfile='/var/log/mysqld-error.log'
slologfile='/var/log/mysqld-slow.log'
genlogfile='/var/log/mysqld-general.log'
mypidfile='/var/run/mysqld/mysqld.pid'

cat << EOF > /root/.my.cnf
[mysqladmin]
user            = root
password        = $ROOT_PASS

[client]
user            = backup
password        = $BACKUP_PASS
host            = %
protocol        = TCP
EOF

chmod 640 /root/.my.cnf

exec /usr/bin/mysqld_safe --defaults-extra-file=/root/.my.cnf --datadir=$datadir \
     --socket=$socketfile --pid-file=$mypidfile --user=mysql & wait
