#!/bin/bash

# This allows you to install SSL certificates for multiple usernames

export SEPARATOR="*******************************************************\n"


echo $SEPARATOR
echo "USAGE: letsencrypt-cpanel-batch USERNAME1 [USERNAME2 USERNAMEn]"
echo "Rate limited to 10 certificates every three hours"
echo "https://community.letsencrypt.org/t/quick-start-guide/1631"

i=1
for USERNAME
do
 if [[ $((i % 10)) -eq 0 && $i -ge 10 ]]; then # Sleep every ten certificates issued 
   echo "Sleeping for 3 hours to comply with Let's Encrypt rate limiting..."
   sleep 10860  # 3 hours and one minute
 fi
 echo $SEPARATOR
 echo "Installing SSL Certificate for Username $((i++)) : ${USERNAME}"
 /usr/local/sbin/letsencrypt-cpanel ${USERNAME} # Register SSL certificate
done

echo $SEPARATOR
echo "Finished registering SSL certificates"