#!/usr/bin/env bash

username=$1
[ -z $username ] && echo "git username must be specified as command line argument" && exit 1

# git log --shortstat --author $USER --since "2 weeks ago" --until "1 week ago" \
#     | grep "files\? changed" \
#     | awk '{files+=$1; inserted+=$4; deleted+=$6} END \
#            {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
#

git log --shortstat --author $username \
    | grep "files\? changed" \
    | awk '{files+=$1; inserted+=$4; deleted+=$6} END \
           {print "[", files, "files changed ] [", inserted ,"lines inserted ] [",  deleted, "lines deleted ]"}'

