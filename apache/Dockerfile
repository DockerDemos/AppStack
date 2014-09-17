# Docker container for an Apache webserver with Shib + PHP-FPM
# http://www.apache.org
#

# MUST USE el6 until patch upstream makes it into packages
# https://github.com/docker/docker/pull/5930
FROM centos:centos6
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y httpd mod_ssl && yum clean all

EXPOSE 80 
EXPOSE 443 

ENTRYPOINT ["/usr/sbin/httpd.worker -DFOREGROUND"]
