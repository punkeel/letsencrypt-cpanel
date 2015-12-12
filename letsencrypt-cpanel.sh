#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/

if [ $# -ne 1 ] && [ $# -ne 2 ]; then
  echo ""
  read -e -p "Enter your cPanel username: " -i "" USERNAME
  test $(/usr/local/sbin/userdomains ${USERNAME}|wc -l) -ne 1 &&\
  echo "USAGE: $0 USERNAME DOMAIN" && exit 0 ||\
  export DOMAIN=$(/usr/local/sbin/userdomains ${USERNAME}) &&\
  echo ""
  echo "Usage: $0 USERNAME [DOMAIN]"
fi

if [ $# -ne 0 ]; then
  export USERNAME=$1
fi

if [ $# -eq 2 ]; then
  export DOMAIN=$2

elif [ $# -eq 1 ]; then
  test $(/usr/local/sbin/userdomains ${USERNAME}|wc -l) -ne 1 &&\
  echo "USAGE: $0 USERNAME DOMAIN" && exit 0 ||\
  export DOMAIN=$(/usr/local/sbin/userdomains ${USERNAME})
fi

echo "Found Domain Name ${DOMAIN}"

/root/letsencrypt/letsencrypt-auto --text certonly --renew-by-default --webroot --webroot-path /home/${USERNAME}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}

/root/installssl.pl ${DOMAIN} 
