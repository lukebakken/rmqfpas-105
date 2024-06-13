#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "[INFO] listing vhost metadata ..."

set +o errexit
for idx in 0 1 2
do
    svc="rmq$idx"
    echo "[INFO] svc: $svc"
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmqctl list_vhosts name default_queue_type
done
