#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/
if [ $# == 1 ] || [ $# == 2 ] || [ $# == 3 ]; then
  export USERNAME=$1
fi
if [ $# == 1 ] || [ $# == 2 ]; then
  test $(/usr/local/sbin/userdomains ${USERNAME}|wc -l) -ne 1 &&\
  echo "USAGE: $0 USERNAME DOMAIN EMAIL" && exit 0 ||\
  export DOMAIN=$(/usr/local/sbin/userdomains ${USERNAME}) &&\
  echo "Found domain name ${DOMAIN}."

elif [ $# == 3 ]; then
  export DOMAIN=$2
  export EMAIL=$3

elif [ $# == 0 ] || [ $# > 3 ]; then
  echo ""
  read -e -p "Enter your cPanel username: " -i "" USERNAME
  test $(/usr/local/sbin/userdomains ${USERNAME}|wc -l) -ne 1 &&\
  echo "USAGE: $0 USERNAME DOMAIN EMAIL" && exit 0 ||\
  export DOMAIN=$(/usr/local/sbin/userdomains ${USERNAME}) &&\
  echo "Found domain name ${DOMAIN}."
  echo ""
  read -e -p "Enter your email address or press enter to accept the default: " -i "webmaster@${DOMAIN}" EMAIL
  echo "Usage: $0 USERNAME [DOMAIN] [EMAIL]"
fi


if [ $# == 3 ]; then
  export EMAIL=$3
elif [ $# == 2 ]; then
  export EMAIL=$2
elif [ $# == 1 ]; then
  export EMAIL=${USERNAME}@${DOMAIN}
fi 

export CRON="0 0 */60 * * /usr/local/sbin/letsencrypt-cpanel.sh ${USERNAME} ${DOMAIN}"

echo "Using email address ${EMAIL}"
/root/letsencrypt/letsencrypt-auto --text --agree-tos --email ${EMAIL} certonly --renew-by-default --webroot --webroot-path /home/${USERNAME}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}
/root/installssl.pl ${DOMAIN}

crontab -l | { cat; echo "${CRON}"; } | crontab -
