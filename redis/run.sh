#!/bin/bash

RUN="$1"
HOST="$(env |awk -F= '/_PORT_6379_TCP_ADDR/ {print $2}')"

if [[ ! -z $2 ]] ; then
  CONTAINER_NAME="$(echo $2 |tr [:lower:] [:upper:])"
fi

case "$1" in
  redis-server)
    exec redis-server
    ;;
  redis-cli)
    exec redis-cli -h $HOST
    ;;
  *)
    echo "I don't understand that command"
    exit 1
    ;;
esac
