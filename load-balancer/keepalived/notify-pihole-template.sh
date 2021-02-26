#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3
HOST=$(hostname)

curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"$HOST\", \"text\": \":exclamation: *PiHole* keepalived on *$HOST* is now in *$STATE* state\", \"icon_emoji\": \":skull:\"}" <SLACK_TOKEN>

case $STATE in
        "MASTER") /usr/bin/docker exec pihole pihole restartdns
                  ;;
esac
