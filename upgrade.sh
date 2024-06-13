#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "[INFO] restarting cluster!"

set +o errexit
for idx in 0 1 2
do
    svc="rmq$idx"
    echo "[INFO] svc: $svc"
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmq-upgrade drain
    docker compose stop "$svc"
    if (( idx < 2 ))
    then
        sleep 10
    fi
	docker compose build --build-arg RABBITMQ_DOCKER_TAG='rabbitmq:3.12-management' "$svc"
    docker compose up --detach --no-deps "$svc"
done
