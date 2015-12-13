# Let's Encrypt for cPanel

## Description

Here is a light wrapper that installs SSL certificates to your cPanel server and automatically renews them using the Let's Encrypt command line tool for cPanel and CentOS 6 and up. 

## Usage

### This step in included in the installation section which installs Let's Encrypt one time per dedicated server.

`letsencrypt-cpanel-install.sh`

### Run one time per domain to set up your new SSL Certificate.

#### New Feature: 

Running this command installs the SSL certificate for all of your cPanel users while respecting Let's Encrypt rate limiting.  

_NOTE: If any of your usernames own more than one domain the script may quit._

`letsencrypt-cpanel-all.sh`

Running the command with no arguments will request cPanel username and email on stdin. If domain cannot be derived it will be requested.

`letsencrypt-cpanel`

Entering the username alone will attempt to derive the domain name and email address or will exit.

`letsencrypt-cpanel $USERNAME`

Entering the username and email address will attempt to derive the domain name or exit.

`letsencrypt-cpanel $USERNAME $EMAIL`

If the domain name cannot be derived because the user owns more than one name then the script will exit if all three arguments are not specified like below.

`letsencrypt-cpanel $USERNAME $DOMAIN $EMAIL`

### Cron for SSL renewal uses  `letsencrypt-cpanel.sh` . 

Usually run by cron for each domain once every 60 days to renew the ssl certificate, but can be manually run.

`letsencrypt-cpanel.sh $USERNAME $DOMAIN`

Entering the username alone will attempt to derive the domain name or will exit.

`letsencrypt-cpanel.sh $USERNAME`

Running the command with no arguments will request cPanel username on stdin. If domain cannot be derived it will be requested.

`letsencrypt-cpanel.sh`

### Batch SSL renewal. 

Can renew the ssl certificate for multiple usernames. If a username owns more than one domain then the script will exit.

`letsencrypt-cpanel-batch.sh $USERNAME [$USERNAME2 $USERNAME3 $USERNAMEn]`

## Installation

_Make sure logged in as root_

`hg clone https://bitbucket.org/webstandardcss/lets-encrypt-for-cpanel-centos-6.x /usr/local/sbin/letsencrypt && ln -s /usr/local/sbin/letsencrypt/letsencrypt-cpanel* /usr/local/sbin/ && /usr/local/sbin/letsencrypt/letsencrypt-cpanel-install.sh`

### Verification

`ls -ald /usr/local/sbin/letsencrypt* /root/{installssl.pl,letsencrypt} /etc/letsencrypt/live/bundle.txt /usr/local/sbin/userdomains && head -n12 /etc/letsencrypt/live/bundle.txt /root/installssl.pl /usr/local/sbin/userdomains && echo "You can check these files and directory listings to ensure that Let's Encrypt is successfully installed."`

When you succeed in installing then you may see the letsencrypt directory and symlinks to the executables in `/usr/local/sbin`.  In `/root/` The letsencrypt source files and a `installssl.pl` file which will install your new SSL certificates into cPanel. Also you can ensure that the intermediate certificates are listed in `/etc/letsencrypt/live/bundle.txt`.

### Uninstall

_Uninstalling will not remove any existing certificates._

`sudo rm -rf /usr/local/sbin/letsencrypt /usr/local/sbin/letsencrypt* /usr/local/sbin/userdomains /root/letsencrypt /root/installssl.pl /etc/letsencrypt/live/bundle.txt && echo "Uninstall Complete: You can paste in verification to ensure the files are gone."`

### How to Enable EPEL Repository for RHEL/CentOS 5.x

CentOS 6.x and up is supported without changing anything. If you need an earlier CentOS then edit the rpm line of `letsencrypt-cpanel-install.sh` below to choose your CentOS version to use with Let's Encrypt.

http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/

### How to determine which of your cPanel Users own multiple domains

If you need to manually run `lets-encrypt-cpanel $USERNAME $DOMAIN $EMAIL` because your cPanel user owns multiple domains then you can run the following command and use this information to easily install the SSL certificates that did not get installed in the batch installation process.

`USERS=$(ls /var/cpanel/users); for i in $USERS; do SITES=$(userdomains $i|wc -l); COUNT=$(echo $SITES $i); echo $COUNT; done|grep -v ^[01] | cut -d" " -f2 > ~/multidomainuser.txt && while read in; do userdomains "$in"; done < ~/multidomainuser.txt|grep -v \* > ~/multipledomain.txt && while read in; do echo $(/scripts/whoowns $in) $in webmaster@${in}; done < ~/multipledomain.txt > ~/multiplelist.txt; echo '#!/bin/bash' && while read in; do echo "/usr/local/sbin/letsencrypt-cpanel $in"; done < ~/multiplelist.txt | awk '1;!(NR%10){print "echo Sleeping 3 hours && sleep 10860";}' | bash && echo "Successfully installed SSL for all cPanel users that own multiple domains`

## Notes

* The script downloads and sets up your python environment to use Let's Encrypt with cPanel
* Then it installs Let's Encrypt into the `/root/` directory
* Script generates the `/root/installssl.pl` and prompts for the root password which is inserted into the WHM api wrapper perl script. 
* The SSL certificate is placed in `/etc/letsencrypt/live/bundle.txt` when installing Let's Encrypt.