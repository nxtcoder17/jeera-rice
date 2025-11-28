#!/usr/bin/env bash

set -e

# Check if required arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <INSTANCE_ID> <LOCAL_PORT:REMOTE_PORT>"
  echo "Example: $0 i-097915fc46c979676 6443:6443"
  exit 1
fi

INSTANCE_ID="$1"
PORT_MAPPING="$2"

# Parse the port mapping
IFS=':' read -r LOCAL_PORT REMOTE_PORT <<<"$PORT_MAPPING"

# Validate that both ports are provided
if [ -z "$LOCAL_PORT" ] || [ -z "$REMOTE_PORT" ]; then
  echo "Error: Port mapping must be in format LOCAL_PORT:REMOTE_PORT"
  echo "Example: 6443:6443"
  exit 1
fi

# Validate that ports are numeric
if ! [[ "$LOCAL_PORT" =~ ^[0-9]+$ ]] || ! [[ "$REMOTE_PORT" =~ ^[0-9]+$ ]]; then
  echo "Error: Ports must be numeric"
  exit 1
fi

echo "Starting port forwarding session..."
echo "Instance: $INSTANCE_ID"
echo "Local port: $LOCAL_PORT -> Remote port: $REMOTE_PORT"

aws ssm start-session \
  --target "$INSTANCE_ID" \
  --document-name AWS-StartPortForwardingSession \
  --parameters "{\"portNumber\":[\"$REMOTE_PORT\"],\"localPortNumber\":[\"$LOCAL_PORT\"]}"
