FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

ENV CMS_PATH https://wordpress.org
ENV CMS_PKG latest.tar.gz

RUN echo -e "\
[EPEL]\n\
name=Extra Packages for Enterprise Linux \$releasever - \$basearch\n\
#baseurl=http://download.fedoraproject.org/pub/epel/\$releasever/\$basearch\n\
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-\$releasever&arch=\$basearch\n\
failovermethod=priority\n\
enabled=1\n\
gpgcheck=0\n\
" >> /etc/yum.repos.d/epel.repo

RUN yum install -y tar sync pwgen && yum clean all

# Download, but don't install here because we mount
# volumes from the data container
RUN curl -sSL $CMS_PATH/$CMS_PKG -o /$CMS_PKG
ADD setup-wordpress.sh /setup-wordpress.sh

ENTRYPOINT ["/setup-wordpress.sh"]
