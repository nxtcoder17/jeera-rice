#! /usr/bin/env sh

name="$1"
openssl genrsa -out "$name.rsa" 2048
openssl rsa -in $1.rsa -pubout > "$name.rsa.pub"
