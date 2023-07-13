#!/usr/bin/env sh
# echo "USAGE: go-test-cover.sh [./path-to-test/...]"

coverprofile=$(mktemp)
go test -coverprofile=$coverprofile $@
go tool cover -html=$coverprofile
[ ! -z $coverprofile ] && rm "$coverprofile"

