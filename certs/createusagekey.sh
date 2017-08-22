#!/bin/bash

# This will create client/server key, 
# to later create client/server cert with

if [ $# -ne 1 ]; then
    echo $#
    echo "Usage: ./createusagekey.sh name"
    exit 1
fi

name=${1} # ie. test@example.com or www.example.com

# Generate key for the client
# the 2048 bits is used because it lowers the load
# but switch to 4096 if needed
cd /root/ca
openssl genrsa -aes256 \
    -out "intermediate/private/${name}.key.pem" 2048
chmod 400 "intermediate/private/${name}.key.pem"
