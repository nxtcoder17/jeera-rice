#! /usr/bin/env bash
host=$1
[ -z "$host" ] && echo "Usage: $0 <host> [<port1>,<port2>,...]"
port=$2

if [ -n "$port" ]; then
	port_arg="-p $port"
fi
nmap -sU -v "$host" "$port_arg"
