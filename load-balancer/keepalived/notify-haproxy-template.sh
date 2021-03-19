#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3
HOST=$(hostname)

curl -X POST  -H 'Content-type: application/json' --data "{\"channel\": \"#general\", \"username\": \"$HOST\", \"content\": \":exclamation: **HAProxy** keepalived on **$HOST** is now in **$STATE** state\", \"avatar_url\": \"https://raw.githubusercontent.com/rogerrum/icons/main/images/skull.png\"}" <DISCORD_WEBHOOK>

case $STATE in
        "MASTER") /usr/bin/docker kill -s HUP haproxy
                  ;;
esac
