#!/usr/bin/env bash

set -o errexit
set -o nounset

echo "[INFO] setting default queue type to quorum..."

docker compose exec --no-TTY rmq0 /opt/rabbitmq/sbin/rabbitmqctl update_vhost_metadata / --default-queue-type quorum
docker compose exec --no-TTY rmq0 /opt/rabbitmq/sbin/rabbitmqctl add_vhost rmqfpas-105
docker compose exec --no-TTY rmq0 /opt/rabbitmq/sbin/rabbitmqctl update_vhost_metadata rmqfpas-105 --default-queue-type quorum
