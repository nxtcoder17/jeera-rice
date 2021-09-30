#! /usr/bin/env sh

KEY_NAME=${1:-ca}
DOMAIN=${2:-localhost.com}

openssl genrsa -out $KEY_NAME.key 2048
openssl rsa -in ${KEY_NAME}.key -pubout -out ${KEY_NAME}.pubkey
openssl rsa -in ${KEY_NAME}.key -out ${KEY_NAME}.privKey

mkdir $DOMAIN

openssl req -new -x509 -nodes -sha256 -days 365 -key ${KEY_NAME}.key -out $DOMAIN/$DOMAIN.crt

# openssl req -new -key ${KEY_NAME}.key -out ./$DOMAIN/$DOMAIN.csr

cat > ./$DOMAIN/$DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

# openssl req -x509 -new -nodes -key ${KEY_NAME}.key -sha256 -days 1825 -out $DOMAIN/${KEY_NAME}.pem

# openssl x509 -req -in ./$DOMAIN/$DOMAIN.csr -CA ./${KEY_NAME}.pem -CAkey ./${KEY_NAME}.key -CAcreateserial \
# -out $DOMAIN/$DOMAIN.crt -days 825 -sha256 -extfile $DOMAIN/$DOMAIN.ext

