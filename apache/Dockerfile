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

ENV FASTCGI https://github.com/clcollins/mod_fastcgi-rpm.git

RUN yum install -y rpm-build rpmdevtools redhat-rpm-config gcc glibc-static autoconf automake httpd-devel apr-devel git which tar httpd mod_ssl

WORKDIR /root
RUN git clone $FASTCGI 
RUN ./mod_fastcgi-rpm/build.sh mod_fastcgi 
RUN yum install -y ./rpmbuild/RPMS/*/*.rpm
RUN yum remove -y rpm-build rpmdevtools redhat-rpm-config gcc glibc-static autoconf automake httpd-devel apr-devel git which tar
WORKDIR /

ADD run-apache.sh /run-apache.sh

EXPOSE 80 
EXPOSE 443 

#ENTRYPOINT ["/run-apache.sh"]
