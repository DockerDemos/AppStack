#!/bin/sh

CMS="$1"
CMSVER="$2"

cd /tmp

if [[ "$CMS" == "WORDPRESS" ]] ; then
  WORDPRESSVER='latest.zip'
  WORDPRESS_URL="https://wordpress.org/$WORDPRESSVER"

  wget $WORDPRESS_URL

  if [[ "$?" == '0' ]] ; then
    unzip /tmp/$WORDPRESSVER
    rsync -az /tmp/wordpress/ /var/www/html/
    rm /tmp/$WORDPRESSVER
    rm -rf /tmp/wordpress
  else
    echo "FAILED TO DOWNLOAD $CMS $CMSVER"
    exit 1
  fi
elif [[ "$CMS" == "DRUPAL" ]] ; then
  DRUPALVER="drupal-$CMSVER.tar.gz"
  DRUPAL_URL="http://ftp.drupal.org/files/projects/$DRUPALVER"

  wget $DRUPAL_URL

  if [[ "$?" == '0' ]] ; then
    tar -xzf /tmp/$DRUPALVER -C /var/www/html/ --strip-components=1
    rm /tmp/$DRUPALVER
  else
    echo "FAILED TO DOWNLOAD $CMS $CMSVER"
    exit 1
  fi
else
  echo "NO VALID CMS SPECIFIED"
  exit 1
fi
