#!/bin/bash

# This prepares dirs for intermediate ca and inter key
# afterwards copy the inter openssl.cnf there

mkdir /root/ca/intermediate

cd /root/ca/intermediate
mkdir certs crl csr newcerts private
chmod -R 700 /root/ca/intermediate
touch index.txt
echo 1000 > serial
echo 100 > crlnumber
chmod 600 index.txt serial crlnumber

cd /root/ca
openssl genrsa -aes256 \
    -out intermediate/private/intermediate.key.pem 4096
chmod 400 intermediate/private/intermediate.key.pem
