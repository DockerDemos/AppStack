#!/bin/sh

f_help() {
  echo -e " 
  Acceptable arguments are: 
    --help  - Print this message
    --shell - Start bash instead of httpd after run \n"
  exit 1
}

if [[ $1 == "--shell" ]] ; then
  RUNSHELL='true'
elif [[ $1 == "--help" ]] ; then
  f_help
elif [[ ! -z $1 ]] ; then
  echo -e "
  Unknown argument."
  f_help
fi

# Check key/cert
# How do I validate that they're legit, too?
if [[ -z $SSLKEY ]] ; then
  echo "NO SSL KEY"
  exit 1
fi

if [[ -z $SSLCERT ]] ; then
  echo "NO SSL CERTIFICATE"
  exit 1
fi

echo -e "$SSLKEY" > /etc/pki/tls/private/localhost.key
echo -e "$SSLCERT" > /etc/pki/tls/certs/localhost.crt

CONFFILE="/etc/httpd/conf/httpd.conf"
SSLFILE="/etc/httpd/conf.d/ssl.conf"

SSLPROTO="SSLProtocol all -SSLv2 -SSLv3"
SSLCIPHERS_OLD="SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM:+LOW"
SSLCIPHERS="SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:ECDHE-RSA-RC4-SHA:ECDHE-ECDSA-RC4-SHA:AES128:AES256:RC4-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!3DES:!MD5:!PSK"

sed -i "s/ServerName www.example.com:80/ServerName $SITE_NAME/" $CONFFILE
sed -i 's/    AllowOverride None/    AllowOverride All/' $CONFFILE
sed -i 's/ServerSignature On/ServerSignature Off/' $CONFFILE

sed -i "s/ServerName www.example.com:80/ServerName $SITE_NAME/" $SSLFILE
sed -i "s/SSLProtocol all -SSLv2/$SSLPROTO/" $SSLFILE
sed -i "s/$SSLCIPHERS_OLD/$SSLCIPHERS/" $SSLFILE

cat << EOF >> $SSLFILE
SSLHonorCipherOrder On
SSLOptions +StrictRequire
SetEnvIf User-Agent ".*MSIE.*" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
EOF

if [[ ! -z $CACERT ]] ; then 
  echo -e "$CACERT" > /etc/pki/tls/certs/ca-bundle.crt
  sed -i 's/#SSLCACertificateFile/SSLCACertificateFile/' $SSLFILE
fi

mkdir -p /var/log/httpd
chown -R apache.root /var/log/httpd

if [[ $RUNSHELL == 'true' ]] ; then
  exec /bin/bash
else
  exec /usr/sbin/httpd -DFOREGROUND
fi
