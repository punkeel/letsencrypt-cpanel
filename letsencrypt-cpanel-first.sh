#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/

if [ ! $# == 2 -o $# == 3 ]; then
  echo "Usage: $0 USER DOMAIN"
  echo "-or-"
  echo "Usage: $0 USER DOMAIN EMAIL"
  exit
fi

export USER=$1
export DOMAIN=$2
export EMAIL=$3
export CRON="0 0 */60 * * /usr/local/sbin/letsencrypt-cpanel.sh ${USER} ${DOMAIN}"


if [ $# == 3 -a $# != 2 ]; then
  echo "Using email address ${EMAIL}"
  /root/letsencrypt/letsencrypt-auto --text --agree-tos --email ${EMAIL} certonly --renew-by-default --webroot --webroot-path /home/${USER}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}
fi

if [ $# == 2 -a $# != 3 ]; then
  echo "Using email address webmaster@${DOMAIN}"
  /root/letsencrypt/letsencrypt-auto --text --agree-tos --email webmaster@${DOMAIN} certonly --renew-by-default --webroot --webroot-path /home/${USER}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}
fi


/root/installssl.pl ${DOMAIN}

crontab -l | { cat; echo "${CRON}"; } | crontab -
