FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN mkdir -p /var/www/html
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /var/log
RUN mkdir -p /var/backup

VOLUME [ '/var/www/html' ]
VOLUME [ '/var/lib/mysql' ]
VOLUME [ '/var/log' ]
VOLUME [ '/var/backup' ]

ENTRYPOINT ["/bin/echo"]
CMD ["'NO APPLICATION NAME SPECIFIED'"]
