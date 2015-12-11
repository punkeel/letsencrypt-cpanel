# Let's Encrypt for cPanel

## Description

Here is a light wrapper that installs SSL certificates to your cPanel server and automatically renews them using the Let's Encrypt command line tool for cPanel and CentOS 6.x. 

## Usage

`letsencrypt-cpanel-install.sh`

Run one time per dedicated server to install Lets Encrypt

`letsencrypt-cpanel-first.sh $USERNAME $DOMAIN`

Run one time per domain to set up a cert. Assuming email address webmaster@$DOMAIN

`letsencrypt-cpanel.sh $USERNAME $DOMAIN`

Usually run by cron for each domain once every 60 days to renew the ssl certificate, but can be manually run.

## Installation

**Make sure logged in as root**

`hg clone https://bitbucket.org/webstandardcss/lets-encrypt-for-cpanel-centos-6.x /usr/local/sbin/letsencrypt && ln -s /usr/local/sbin/letsencrypt/letsencrypt-cpanel* /usr/local/sbin/ && /usr/local/sbin/letsencrypt/letsencrypt-cpanel-install.sh`

### Verification

`ls -al /usr/local/sbin/ && ls -al /root && head -n100 /etc/letsencrypt/live/bundle.txt`

When you succeed in installing then you may see the letsencrypt directory and symlinks to the executables in `/usr/local/sbin`.  In `/root/` The letsencrypt source files and a `installssl.pl` file which will install your new SSL certificates into cPanel. Also you can ensure that the intermediate certificates are listed in `/etc/letsencrypt/live/bundle.txt`.

### How to Enable EPEL Repository for RHEL/CentOS 7.x/6.x/5.x

If you need a different CentOS then edit the rpm line of `letsencrypt-cpanel-install.sh` below to choose your CentOS version to use with Let's Encrypt.

http://www.tecmint.com/how-to-enable-epel-repository-for-rhel-centos-6-5/

## Notes

* The script downloads and sets up your python environment to use Let's Encrypt with cPanel
* Then it installs Let's Encrypt into the `/root/` directory
* Script generates the `/root/installssl.pl` and prompts for the root password which is inserted into the WHM api wrapper perl script. 
* The SSL certificate is placed in `/etc/letsencrypt/live/bundle.txt` when installing Let's Encrypt.