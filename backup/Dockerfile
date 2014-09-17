FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

ENV container docker

RUN yum install -y mariadb && yum clean all
ADD mysql-backup.sh /mysql-backup.sh

CMD ["/mysql-backup.sh"]

