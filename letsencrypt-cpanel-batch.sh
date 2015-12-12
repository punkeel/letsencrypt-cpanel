#!/bin/bash

# This allows you to install SSL certificates for multiple usernames

echo "Usage: letsencrypt-cpanel-batch USERNAME1 [USERNAME2 USERNAMEn]"

i=1
for USERNAME
do
 echo "Installing SSL Certificate for Username $((i++)) : ${USERNAME}"
 /usr/local/sbin/letsencrypt-cpanel ${USERNAME}
done
