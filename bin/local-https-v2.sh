#! /usr/bin/env sh

DOMAIN=$1

openssl req -x509 -out $DOMAIN.crt -keyout $DOMAIN.key \
  -days 365 \
  -newkey rsa:2048 -nodes -sha256 \
  -subj "/CN=$DOMAIN" -extensions EXT -config <( \
   printf "[dn]\nCN=$DOMAIN\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:$DOMAIN\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
