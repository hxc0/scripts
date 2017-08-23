#!/bin/bash

# This will create the root CA cert, which will be in turn used to 
# create intermediate CA, creating a chain of trust

cd /root/ca

openssl req -config openssl.cnf \
    -key private/ca.key.pem \
    -new -x509 -days 7300 -sha256 -extensions v3_ca \
    -out certs/ca.cert.pem

chmod 444 certs/ca.cert.pem

openssl x509 -noout -text -in certs/ca.cert.pem
