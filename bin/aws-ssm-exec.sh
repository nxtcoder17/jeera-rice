#! /usr/bin/env bash

INSTANCE_ID="$1"
shift 1;
COMMAND="$@"

COMMAND_ID=$(aws ssm send-command \
  --document-name "AWS-RunShellScript" \
  --targets "Key=instanceids,Values=$INSTANCE_ID" \
  --parameters "commands=['$COMMAND']" \
  --query "Command.CommandId" \
  --output text)

aws ssm wait command-executed \
  --command-id "$COMMAND_ID" \
  --instance-id $INSTANCE_ID

aws ssm get-command-invocation \
  --command-id "$COMMAND_ID" \
  --instance-id $INSTANCE_ID \
  --query "StandardOutputContent" \
  --output text
