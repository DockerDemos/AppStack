# Docker container for an Apache webserver with mod_php 
# http://www.apache.org
#
# Due to a bug MUST USE el6 until patch upstream makes it into packages
# unless the image will be built on a RHEL-based (CentOS, Scientific Linux) host
#
# See:
# https://github.com/docker/docker/pull/5930
#
# If you have a RHEL-based server and want to use a CentOS 7 image, checkout
# the 'apache-el7' branch

FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y httpd php php-mysql mod_ssl && yum clean all
ADD run-apache.sh /run-apache.sh

EXPOSE 80 
EXPOSE 443 

ENTRYPOINT ["/run-apache.sh"]
