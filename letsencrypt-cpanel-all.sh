#!/bin/bash

# This allows you to install SSL certificates for all cPanel usernames
export SEPARATOR="*******************************************************\n"
echo $SEPARATOR
echo "USAGE: letsencrypt-cpanel-batch.sh"

/usr/local/sbin/letsencrypt-cpanel-batch.sh $(ls /var/cpanel/users)

echo $SEPARATOR
echo "Finished registering SSL certificates for all cPanel users"