#!/bin/sh

ARG="$1"
PKGS="pwgen rsync"
SCPTDIR="/build-scripts"
declare -a SCPTS=""

if [ "$ARG" = '--help' ] ; then
  # Some help text here maybe
  true
fi

# EPEL Repo for extra packages
/bin/cat << EOF > /etc/yum.repos.d/epel.repo
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
#baseurl=http://download.fedoraproject.org/pub/epel/6/\$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
EOF

if [ ! -z "$DB" ] ; then
  PKGS="$PKGS mariadb-server"
  SCPTS=("${SCPTS[@]}" "setup-mysql.sh")
fi

if [ ! -z "$CMS" ] ; then
  if [ -z "$CMSVER" ] ; then
    echo "NO CMS VERSION SPECIFIED"
    exit 1
  fi
  PKGS="$PKGS wget unzip tar"
  SCPTS=("${SCPTS[@]}" "setup-cms.sh $CMS $CMSVER") 
fi

yum install -y $PKGS ; yum clean all

# REMOVE EMPTY PLACEHOLDER
unset SCPTS[0]

for SCPT in "${SCPTS[@]}"
  do
    bash -x $SCPTDIR/$SCPT
    if [ "$?" != '0' ] ; then 
      echo "SOMETHING WENT WRONG"
      exit 1
    fi
done
