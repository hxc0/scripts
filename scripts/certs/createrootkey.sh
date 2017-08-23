#!/bin/bash

# Creates root key -this is master key that is used to issue all other certs,
# Including the CA cert. It will be used to create the root cert

mkdir /root/ca
cd /root/ca
mkdir certs crl newcerts private
chmod -R 0700 /root/ca
touch index.txt
chmod 600 index.txt
echo 1000 > serial
chmod 600 serial

openssl genrsa -aes256 -out private/ca.key.pem 4096

chmod 400 private/ca.key.pem
