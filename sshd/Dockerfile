FROM ubuntu:14.04
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
