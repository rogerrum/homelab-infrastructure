#!/bin/bash

IMAGE=haproxy:alpine
NAME=haproxy

docker stop haproxy
docker rm haproxy

if ! docker pull $IMAGE | tee /dev/stderr | grep -q "Image is up to date"
then
  echo "removing old $NAME for $IMAGE"
  docker stop $NAME
  docker rm -f $NAME
fi

if ! docker ps --filter=name="$NAME" --filter=status="running" | grep $NAME
then
  echo "running $NAME"

docker run \
    -d \
    --name $NAME \
    --restart always \
    --net=host \
    -v /mnt/appdata/haproxy/:/usr/local/etc/haproxy/:ro \
    $IMAGE
fi

