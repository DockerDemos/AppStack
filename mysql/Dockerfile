FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y mariadb-server cronie ; yum clean all
RUN mkdir -p /var/backup/mysql
RUN echo "0 2 * * * mysqldump -u root --all-databases > /var/backup/mysql/backup.sql" > /etc/cron.d/mysql.cron

ENTRYPOINT ["/bin/bash"]

