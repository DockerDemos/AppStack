#!/bin/sh

mysqldump -u backup -p$BACKUP_PASS -h $DB_PORT_3306_TCP_ADDR -A -C > /var/backup/mysql.sql
