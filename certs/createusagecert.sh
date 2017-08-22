#!/bin/bash

# This will create a CSR and then sign the cert
# for the client/server using the intermediate CA cert
# The client/server key and cert can be deployed, 
# alongside with the ca-chain cert, to the client/server

# Exit if no name and usage sepcified
if [ $# -ne 2 ]; then
    echo "Usage ./createusagecert client/server name"
    echo -e "\033[01;31mPlease remember to use the same name for Common Name\033[0m"
    exit 1
fi

usage=$1
name=$2
echo "Usage: ${usage}"
echo "Name: ${name}"

if [ "${usage}" != "server" -a "${usage}" != "client" ]; then
    echo -e "Usage has to be either \033[01;33mclient\033[0m or \033[01;34mserver\033[0m"
    exit 2
fi

cd /root/ca
# Create CSR using inter openssl conf, and client/server key
# the Common Name has to be the name!
echo -e "\033[01;33m# Creating Certificate Signing Request for ${usage} ${name}...\033[0m\n"
echo -e "\033[01;31m----------------------------------------------------------------"
echo "Rememeber that the common name has to be the same as in argument"
echo -e "----------------------------------------------------------------\033[0m\n"
openssl req -config intermediate/openssl.cnf \
    -key intermediate/private/${name}.key.pem \
    -new -sha256 \
    -out intermediate/csr/${name}.csr.pem
echo -e "\033[01;33m# CSR Created\033[0m\n"
echo -e "\033[01;33m# Signing CSR using intermediate CA...\033[0m"
openssl ca -config intermediate/openssl.cnf \
    -extensions ${usage}_cert -days 1800 -notext -md sha256 \
    -in intermediate/csr/${name}.csr.pem \
    -out intermediate/certs/${name}.cert.pem
chmod 444 intermediate/certs/${name}.cert.pem

# Verify the cert
echo -e "\n\033[01;33m# Verifying the ${usage} cert...\033[0m"
openssl x509 -noout -text \
    -in intermediate/certs/${name}.cert.pem
echo ""
openssl verify -CAfile intermediate/certs/ca-chain.cert.pem \
    intermediate/certs/${name}.cert.pem

echo -e "\n\033[01;33m----------------------------------------------------------------"
echo -e "# Cert \033[01;32m/root/ca/intermediate/certs/${name}.cert.pem \033[01;32mcreated"
echo -e "# Copy the following files to your ${usage}:\n"
echo -e "\033[01;32m/root/ca/intermediate/certs/${name}.cert.pem"
echo -e "\033[01;34m/root/ca/intermediate/private/${name}.key.pem"
echo -e "\033[01;35m/root/caintermediate/certs/ca-chain.cert.pem\n"
echo -e "\n\033[01;33m----------------------------------------------------------------"
echo -e "\033[01;33m# Done\033[0m"
