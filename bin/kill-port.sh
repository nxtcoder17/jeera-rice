#!/usr/bin/env bash

for port in "${@}"; do
  tcp_pid=$(lsof -i tcp:$port | tail -n +2 | awk '{print $2}')
  [ -z "$tcp_pid" ] || kill -9 $tcp_pid

  udp_pid=$(lsof -i udp:$port | tail -n +2 | awk '{print $2}')
  [ -z "$udp_pid" ] || kill -9 $udp_pid
done
