#!/bin/sh mysql='/usr/bin/mysqld_safe' datadir='/var/lib/mysql'
socketfile="\$datadir/mysql.sock"
errlogfile='/var/log/mysqld-error.log'
slologfile='/var/log/mysqld-slow.log'
genlogfile='/var/log/mysqld-general.log'
mypidfile='/var/run/mysqld/mysqld.pid'

if [[ ! -f "\$errlogfile" ]] ; then
	  touch "\$errlogfile" 2>/dev/null
	    touch "\$slologfile" 2>/dev/null
	      touch "\$genlogfile" 2>/dev/null
      fi

      chown mysql:mysql "\$errlogfile" "\$slologfile" "\$genlogfile"
      chmod 0640 "\$errlogfile" "\$slologfile" "\$genlogfile"

      if [[ ! -d "\$datadir" ]] ; then
	        mkdir -p "\$datadir"
		  chown mysql:mysql "\$datadir"
		    chmod 0755 "\$datadir"
		      /usr/bin/mysql_install_db --datadir="\$datadir" --user=mysql
		        chmod 0755 "\$datadir"
		fi

		chown mysql:mysql "\$datadir"
		chmod 0755 "\$datadir"

		\$mysql   --datadir="\$datadir" --socket="\$socketfile" \
			         --pid-file="\$mypidfile" \
				          --basedir=/usr --user=mysql >/dev/null 2>&1 & wait
		EOF
