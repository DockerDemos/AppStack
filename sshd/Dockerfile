# Docker container for SSH access to data volumes
# Using LDAP (grouper) groups

FROM centos:centos7
MAINTAINER Chris Collins <collins.christopher@gmail.com>

RUN yum install -y openssh-server sssd && yum clean all

# SSHD Setup
RUN echo -e "\
Port 22\n\
Protocol 2\n\
SyslogFacility AUTHPRIV\n\
PermitRootLogin no\n\
\n\
ChallengeResponseAuthentication no\n\
\n\
#ForceCommand /usr/sbin/login_duo\n\
\n\
GSSAPIAuthentication yes\n\
GSSAPICleanupCredentials yes\n\
UsePAM yes\n\
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES\n\
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT\n\
AcceptEnv LC_IDENTIFICATION LC_ALL\n\
AllowTcpForwarding no\n\
X11Forwarding yes\n\
Subsystem       sftp    /usr/libexec/openssh/sftp-server\n\
DenyUsers oracle oralsnr\n\
ClientAliveInterval 14400\n\
ClientAliveCountMax 0\n\
PubkeyAuthentication yes\n\
PasswordAuthentication yes\n\
" > /etc/ssh/sshd_config

# Fix for SSHD PAM issue
# See: http://chris.collins.is/2013/12/chris.html
# Check to see if this is still needed
RUN sed -i  's/session  required  pam_loginuid.so/session  optional  pam_loginuid.so/'  /etc/pam.d/sshd

# nsswitch.conf setup
RUN set -e 's/bootparams: nisplus [NOTFOUND=return] files/bootparams: files/ \
s/services:   files sss/services:   files/ \
s/netgroup:   nisplus sss/netgroup:   files ldap/ \
s/publickey:  nisplus/publickey:  files/ \
s/automount:  files nisplus/automount:  files ldap/ \
s/aliases:    files nisplus/aliases:    files/ \
' /etc/nsswitch.conf

# SSSD setup
#ADD sssd.conf /etc/sssd/sssd.conf <-- Secret stuff

# LDAP Certs
#ADD certs/* /etc/ssl/certs/

# Duo Unix?  Do we need this?
# yum install duo_unix
# /etc/duo/login_duo.conf <-- secret stuff
# /etc/duo/pam_duo.conf   <-- secret stuff

EXPOSE 22 

#ENTRYPOINT ["/run-server.sh"]
