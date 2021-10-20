#! /usr/bin/env sh

KEY_NAME=${1:-ca}
DOMAIN=${2:-localhost.com}

[ -d certs ] || mkdir certs
KEY_FILE=certs/$KEY_NAME.key
PEM_FILE=certs/$KEY_NAME.pem

# generating private key (AES encryption)
openssl genrsa -out $KEY_FILE 3072

# generating root certificate
openssl req -x509 -new -nodes -key $KEY_FILE -sha256 -days 360 -out $PEM_FILE

[ -d $DOMAIN ] || mkdir $DOMAIN

# certificate private key
openssl genrsa -out $DOMAIN/$DOMAIN.key 3072

# certificate signing request
openssl req -new -key $DOMAIN/$DOMAIN.key -out $DOMAIN/$DOMAIN.csr

cat > $DOMAIN/$DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

openssl x509 -req -in $DOMAIN/$DOMAIN.csr -CA $PEM_FILE -CAkey $KEY_FILE -CAcreateserial \
  -out $DOMAIN/$DOMAIN.crt -days 360 -sha256 -extfile $DOMAIN/$DOMAIN.ext

