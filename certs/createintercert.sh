#!/bin/bash

# Uses inter key to create a certificate signing request
# Remember that the common name must be different than root CA
# Afterwards signs the CSR to create cert

cd /root/ca
#This will use the inter openssl conf
openssl req -config intermediate/openssl.cnf \
    -new -sha256 \
    -key intermediate/private/intermediate.key.pem \
    -out intermediate/csr/intermediate.csr.pem

cd /root/ca
# This will sign the CSR to create cert,
# It uses the root ca openssl conf
# The time to live of cert should be lower than CAs
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
    -days 3650 -notext -md sha256 \
    -in intermediate/csr/intermediate.csr.pem \
    -out intermediate/certs/intermediate.cert.pem
chmod 444 intermediate/certs/intermediate.cert.pem

# Verify the inter cert
openssl x509 -noout -text \
    -in intermediate/certs/intermediate.cert.pem

# Verify the inter cert against the root cert.
# OK indicates that chain of trust is intact
openssl verify -CAfile certs/ca.cert.pem \
    intermediate/certs/intermediate.cert.pem

# Create the cert chain file
# This is used to present an application the chain which will
# be used as a chain of trust.
cat intermediate/certs/intermediate.cert.pem \
    certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
chmod 444 intermediate/certs/ca-chain.cert.pem
