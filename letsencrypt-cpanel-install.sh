#!/bin/bash

echo "Generated file is located at: /root/installssl.pl"
echo "cPanel API can install your generate cert."
echo "Enter your root password: "

read ROOTPASS

rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
rpm -ivh https://rhel6.iuscommunity.org/ius-release.rpm
yum -y install git python27 python27-devel python27-pip python27-setuptools python27-virtualenv --enablerepo=ius
cd /root
git clone https://github.com/letsencrypt/letsencrypt
cd /root/letsencrypt
sed -i "s|--python python2|--python python2.7|" letsencrypt-auto
./letsencrypt-auto --verbose

echo ** Done installing python and letsencrypt

touch /root/installssl.pl
chmod 755 /root/installssl.pl
cat << "EOF" > /root/installssl.pl
#!/usr/local/cpanel/3rdparty/bin/perl

use strict;
use LWP::UserAgent;
use LWP::Protocol::https;
use MIME::Base64;
use IO::Socket::SSL;
use URI::Escape;

my $user = "root";
EOF

cat << EOF >> /root/installssl.pl
my \$pass = "${ROOTPASS}";
EOF

cat << "EOF" >> /root/installssl.pl
my $auth = "Basic " . MIME::Base64::encode( $user . ":" . $pass );

my $ua = LWP::UserAgent->new(
    ssl_opts   => { verify_hostname => 0, SSL_verify_mode => 'SSL_VERIFY_NONE', SSL_use_cert => 0 },
);

my $dom = $ARGV[0];

my $certfile = "/etc/letsencrypt/live/$dom/cert.pem";
my $keyfile = "/etc/letsencrypt/live/$dom/privkey.pem";
my $cafile =  "/etc/letsencrypt/live/bundle.txt";

my $certdata;
my $keydata;
my $cadata;

open(my $certfh, '<', $certfile) or die "cannot open file $certfile";
    {
        local $/;
        $certdata = <$certfh>;
    }
    close($certfh);

open(my $keyfh, '<', $keyfile) or die "cannot open file $keyfile";
    {
        local $/;
        $keydata = <$keyfh>;
    }
    close($keyfh);

open(my $cafh, '<', $cafile) or die "cannot open file $cafile";
    {
        local $/;
        $cadata = <$cafh>;
    }
    close($cafh);

my $cert = uri_escape($certdata);
my $key = uri_escape($keydata);
my $ca = uri_escape($cadata);

my $request = HTTP::Request->new( POST => "https://127.0.0.1:2087/json-api/installssl?api.version=1&domain=$dom&crt=$cert&key=$key&cab=$ca" );
$request->header( Authorization => $auth );
my $response = $ua->request($request);
print $response->content;
EOF

cat << EOFFF > /etc/letsencrypt/live/bundle.txt
-----BEGIN CERTIFICATE-----
MIIEqDCCA5CgAwIBAgIRAJgT9HUT5XULQ+dDHpceRL0wDQYJKoZIhvcNAQELBQAw
PzEkMCIGA1UEChMbRGlnaXRhbCBTaWduYXR1cmUgVHJ1c3QgQ28uMRcwFQYDVQQD
Ew5EU1QgUm9vdCBDQSBYMzAeFw0xNTEwMTkyMjMzMzZaFw0yMDEwMTkyMjMzMzZa
MEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQD
ExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMTCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAJzTDPBa5S5Ht3JdN4OzaGMw6tc1Jhkl4b2+NfFwki+3uEtB
BaupnjUIWOyxKsRohwuj43Xk5vOnYnG6eYFgH9eRmp/z0HhncchpDpWRz/7mmelg
PEjMfspNdxIknUcbWuu57B43ABycrHunBerOSuu9QeU2mLnL/W08lmjfIypCkAyG
dGfIf6WauFJhFBM/ZemCh8vb+g5W9oaJ84U/l4avsNwa72sNlRZ9xCugZbKZBDZ1
gGusSvMbkEl4L6KWTyogJSkExnTA0DHNjzE4lRa6qDO4Q/GxH8Mwf6J5MRM9LTb4
4/zyM2q5OTHFr8SNDR1kFjOq+oQpttQLwNh9w5MCAwEAAaOCAZIwggGOMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQDAgGGMH8GCCsGAQUFBwEBBHMwcTAy
BggrBgEFBQcwAYYmaHR0cDovL2lzcmcudHJ1c3RpZC5vY3NwLmlkZW50cnVzdC5j
b20wOwYIKwYBBQUHMAKGL2h0dHA6Ly9hcHBzLmlkZW50cnVzdC5jb20vcm9vdHMv
ZHN0cm9vdGNheDMucDdjMB8GA1UdIwQYMBaAFMSnsaR7LHH62+FLkHX/xBVghYkQ
MFQGA1UdIARNMEswCAYGZ4EMAQIBMD8GCysGAQQBgt8TAQEBMDAwLgYIKwYBBQUH
AgEWImh0dHA6Ly9jcHMucm9vdC14MS5sZXRzZW5jcnlwdC5vcmcwPAYDVR0fBDUw
MzAxoC+gLYYraHR0cDovL2NybC5pZGVudHJ1c3QuY29tL0RTVFJPT1RDQVgzQ1JM
LmNybDATBgNVHR4EDDAKoQgwBoIELm1pbDAdBgNVHQ4EFgQUqEpqYwR93brm0Tm3
pkVl7/Oo7KEwDQYJKoZIhvcNAQELBQADggEBANHIIkus7+MJiZZQsY14cCoBG1hd
v0J20/FyWo5ppnfjL78S2k4s2GLRJ7iD9ZDKErndvbNFGcsW+9kKK/TnY21hp4Dd
ITv8S9ZYQ7oaoqs7HwhEMY9sibED4aXw09xrJZTC9zK1uIfW6t5dHQjuOWv+HHoW
ZnupyxpsEUlEaFb+/SCI4KCSBdAsYxAcsHYI5xxEI4LutHp6s3OT2FuO90WfdsIk
6q78OMSdn875bNjdBYAqxUp2/LEIHfDBkLoQz0hFJmwAbYahqKaLn73PAAm1X2kj
f1w8DdnkabOLGeOVcj9LQ+s67vBykx4anTjURkbqZslUEUsn2k5xeua2zUk=
-----END CERTIFICATE-----
EOFFF


echo '** Done installing certificate'

echo '**** Usage below' 

echo '** NOTE: Will need to make sure that /root/installpl.ssl exists. see https://forums.cpanel.net/threads/how-to-installing-ssl-from-lets-encrypt.513621/ for details.'

echo '****'
