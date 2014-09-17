#!/bin/sh

if [[ "$(ls -A /var/www/html)" ]] ; then
  echo "SOMETHING ALREADY INSTALLED"
  exit 1
else
  cd /
  unzip /latest.zip
  rsync -az /wordpress/ /var/www/html/
  rm -rf /wordpress
fi
