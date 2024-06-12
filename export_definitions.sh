#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "[INFO] setting default queue type to quorum..."

set +o errexit
for idx in 0 1 2
do
    svc="rmq$idx"
    # NB: https://github.com/docker/compose/issues/1262
    container_id="$(docker compose ps -q "$svc")"
    echo "[INFO] svc: $svc"
    docker exec "$container_id" /opt/rabbitmq/sbin/rabbitmqctl update_vhost_metadata / --default-queue-type quorum
done
