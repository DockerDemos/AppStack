FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y mariadb-server && yum clean all
ADD setup-mysql.sh /setup-mysql.sh 

ENTRYPOINT ["/setup-mysql.sh"]
