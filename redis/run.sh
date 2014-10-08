#!/bin/bash

RUN="$1"
HOST="$(env |awk -F= '/_PORT_6379_TCP_ADDR/ {print $2}')"

if [[ ! -z $2 ]] ; then
  CONTAINER_NAME="$(echo $2 |tr [:lower:] [:upper:])"
  echo "Redis Host: $CONTAINER_NAME"
fi

case "$1" in
  redis-server)
    exec redis-server
    ;;
  redis-cli)
    echo "Redis Connect: \$${CONTAINER_NAME}_PORT_6379_TCP_ADDR"
    exec redis-cli -h $HOST
    ;;
  *)
    echo "I don't understand that command"
    exit 1
    ;;
esac
