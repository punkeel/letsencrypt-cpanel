Here is another version 2 of the wrapper that installs SSL certificates to your cPanel server and automatically renews them using the Let's Encrypt command line tool for cPanel and CentOS 6.x. 

If you need a different CentOS then edit the rpm line of letsencrypt-cpanel-install.sh and see this page for the correct entry.
How to Enable EPEL Repository for RHEL/CentOS 7.x/6.x/5.x

The script downloads and sets up your python environment to use Let's Encrypt with cPanel

Then it installs Let's Encrypt into the /root directory

Script generates the `/root/installssl.pl` and prompts for the root password which is inserted into the WHM api wrapper perl script. 

The SSL certificate is placed in the correct location when installing Let's Encrypt.

There are three files which should be saved to `/usr/local/sbin/`

`letsencrypt-cpanel-install.sh`

Run one time per dedicated server to install Lets Encrypt

`letsencrypt-cpanel-first.sh $USERNAME $DOMAIN`

Run one time per domain to set up a cert. Assuming email address webmaster@$DOMAIN

`letsencrypt-cpanel.sh $USERNAME $DOMAIN`

Usually run by cron for each domain once every 60 days to renew the ssl certificate, but can be manually run.