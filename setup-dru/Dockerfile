#Requires el6 until http install can be fixed in EL7
FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

ENV CMS_PATH http://ftp.drupal.org/files/projects
ENV CMS_PKG drupal-7.31.tar.gz

ENV COMPOSER_PKG https://getcomposer.org/installer
ENV DRUSH_PKG https://github.com/drush-ops/drush/archive/master.tar.gz

# This should change to mariadb when we move to EL7
ENV DB_PKG mysql

RUN echo -e "\
[EPEL]\n\
name=Extra Packages for Enterprise Linux \$releasever - \$basearch\n\
#baseurl=http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch\n\
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-\$releasever&arch=\$basearch\n\
failovermethod=priority\n\
enabled=1\n\
gpgcheck=0\n\
" >> /etc/yum.repos.d/epel.repo

RUN echo -e "\
[ius]\n\
name=IUS Community Project repository \$releasever - \$basearch\n\
baseurl=http://dl.iuscommunity.org/pub/ius/stable/CentOS/\$releasever/\$basearch/\n\
enabled=1\n\
gpgcheck=0\n\
" >> /etc/yum.repos.d/ius.repo

# which required for Drush to find PHP
# git required for Composer install
RUN yum install -y git which tar pwgen php55u php55u-gd php55u-mysqlnd php55u-xml $DB_PKG && yum clean all
RUN curl -sS $COMPOSER_PKG | php -- --install-dir=/usr/bin
RUN mv /usr/bin/composer.phar /usr/bin/composer

RUN mkdir /drush
RUN curl -sSL $DRUSH_PKG |tar xz -C /drush --strip-components=1
RUN /bin/chmod u+x /drush/drush
RUN /bin/ln -s /drush/drush /usr/bin/drush

WORKDIR /drush
RUN composer install
RUN composer global require drush/drush:6.*

WORKDIR /

# Download, but don't install here because we mount
# volumes from the data container
RUN curl $CMS_PATH/$CMS_PKG -o /$CMS_PKG
ADD setup-drupal.sh /setup-drupal.sh

ENTRYPOINT ["/setup-drupal.sh"]

