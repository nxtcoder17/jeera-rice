#! /usr/bin/env sh

FILE=$1
L_NO=$2
ENV=${3:-dev}

echo dot-http -e $ENV -l $L_NO  "$FILE" | lolcat -t -F 0.05
dot-http -e $ENV -l $L_NO  "$FILE"
