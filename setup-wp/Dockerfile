FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y unzip rsync && yum clean all
ADD latest.zip /latest.zip
ADD setup-wordpress.sh /setup-wordpress.sh

ENTRYPOINT ["/setup-wordpress.sh"]
