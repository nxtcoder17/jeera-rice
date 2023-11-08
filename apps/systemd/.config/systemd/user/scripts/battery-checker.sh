#! /usr/bin/env bash

POW=$(acpi -b | awk -F, '{printf $2}' | sed 's/%//g' | sed 's/\s//g')
test $POW -gt 20 && notify-send "Low Battery $POW"
