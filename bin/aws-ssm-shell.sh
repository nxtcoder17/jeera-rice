#!/usr/bin/env bash

INSTANCE_ID="$1"

if [ -z "$INSTANCE_ID" ]; then
  echo "must pass INSTANCE_ID as argument"
  exit 1
fi

aws ssm start-session --target "$INSTANCE_ID"
