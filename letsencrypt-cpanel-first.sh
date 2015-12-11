#!/bin/bash
# https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/

if [ $# == 1 ] || [ $# == 2 ] || [ $# == 3 ]; then
  test $(userdomains ${USER}|wc -l) -ne 1 &&\
  echo "USAGE: $0 USER DOMAIN EMAIL" && exit 0 ||\
  export DOMAIN=$(userdomains ${USER}) &&\
  echo "Found domain name ${DOMAIN}."

  export USER=$1

  if [ $# == 3 ]; then
    export DOMAIN=$3
  elif [ $# == 1 ] || [ $# == 2]; then
    export DOMAIN=$(/usr/local/sbin/userdomains ${USER})
  fi  

  if [ $# == 2 ]; then
    export EMAIL=$2
  elif [ $# == 1 ]; then
    export EMAIL=${USER}@${DOMAIN}
  fi 

elif [ $# == 0 ] || [ $# >= 3 ]; then
  echo ""
  read -e -p "Enter your cPanel username: " -i "" USER
  export DOMAIN=$(/usr/local/sbin/userdomains ${USER})
  echo ""
  read -e -p "Enter your email address or press enter to accept the default: " -i "webmaster@${DOMAIN}" EMAIL
  echo "Usage: $0 USER [EMAIL]"
  exit
fi

export CRON="0 0 */60 * * /usr/local/sbin/letsencrypt-cpanel.sh ${USER} ${DOMAIN}"

echo "Using email address ${EMAIL}"
/root/letsencrypt/letsencrypt-auto --text --agree-tos --email ${EMAIL} certonly --renew-by-default --webroot --webroot-path /home/${USER}/public_html/ -d ${DOMAIN} -d www.${DOMAIN}
/root/installssl.pl ${DOMAIN}

crontab -l | { cat; echo "${CRON}"; } | crontab -
