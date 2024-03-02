#!/bin/bash

# Variables
SERVER_CN="SERVERCN"
CLIENT_CN="CLIENTCN"
CA_CN="CA"
ORG="divigraph"
OU="Software"
O="Caracal"
L="Cape Town"
ST="WC"
C="ZA"
PASSPHRASE="admin"
DAYS=3650

# Generate CA private key and self-signed certificate
openssl req -new -x509 -days $DAYS -extensions v3_ca -keyout ca.key -out ca.pem -subj "/CN=$CA_CN/OU=$OU/O=$ORG/L=$L/ST=$ST/C=$C" -passin pass:$PASSPHRASE -passout pass:$PASSPHRASE

# Generate server private key
openssl genrsa -out server.key 2048

# Generate server CSR
openssl req -new -key server.key -out server.csr -subj "/CN=$SERVER_CN/OU=$OU/O=$ORG/L=$L/ST=$ST/C=$C"

# Sign server certificate with CA
openssl x509 -req -days $DAYS -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -passin pass:$PASSPHRASE

# Generate client private key
openssl genrsa -out client.key 2048

# Generate client CSR
openssl req -new -key client.key -out client.csr -subj "/CN=$CLIENT_CN/OU=$OU/O=$ORG/L=$L/ST=$ST/C=$C"

# Sign client certificate with CA
openssl x509 -req -days $DAYS -in client.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out client.pem -passin pass:$PASSPHRASE

# Add CA certificate to Solace broker's trusted CA list
# Replace '/path/to/solace/cert/' with your Solace broker's certificate directory
#cp ca.pem /path/to/solace/cert/

# Add server and client certificates to Solace broker's certificate directory
#cp server.pem /path/to/solace/cert/
#cp client.pem /path/to/solace/cert/

# Restart Solace broker to apply changes (if necessary)
# systemctl restart solace
