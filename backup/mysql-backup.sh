#!/bin/sh

mysqldump -u backup -pTIMBPYB -h $DB_PORT_3306_TCP_ADDR -A -C > /var/backup/mysql.sql
