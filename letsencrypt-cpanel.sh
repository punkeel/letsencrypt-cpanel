#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/

if [ ! $# == 2 ]; then
  echo "Usage: $0 USER DOMAIN"
  exit
fi

export USER=$1
export DOMAIN=$2

/root/letsencrypt/letsencrypt-auto --text certonly --renew-by-default --webroot --webroot-path /home/${USER}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}
~
/root/installssl.pl ${DOMAIN} 
