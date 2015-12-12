#!/bin/bash

# This allows you to install SSL certificates for multiple usernames

echo "Usage: letsencrypt-cpanel-batch USERNAME1 [USERNAME2 USERNAMEn]"
echo "Rate limited issuing 10 certificates every three hours"
echo "https://community.letsencrypt.org/t/quick-start-guide/1631"

i=1
for USERNAME
do
 #if [[ $(( i % 10 = 0 )) && $(( i >= 10 )) ]] # Sleep every ten certificates issued
 #  then sleep 10860  # 3 hours and one minute
 #done
 echo "Installing SSL Certificate for Username $((i++)) : ${USERNAME}"
 /usr/local/sbin/letsencrypt-cpanel ${USERNAME} # Register SSL certificate
done
