# Docker container for an Apache webserver with mod_php 
# http://www.apache.org
#

# Image can only be built on RHEL-based, 
# (CentOS, Scientific Linux) servers due to bug; see
# https://github.com/docker/docker/pull/5930
#
# If you want to build on another host, checkout the master branch 
# for the centos:centos6 version

FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y httpd php php-mysql mod_ssl && yum clean all
ADD run-apache.sh /run-apache.sh

EXPOSE 80 
EXPOSE 443 

ENTRYPOINT ["/run-apache.sh"]
