#!/usr/bin/env bash

set -o errexit
set -o nounset

curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly curdir

"$curdir/update_vhost_metadata.sh"
"$curdir/list_vhost_metadata.sh"
"$curdir/export_definitions.sh"

echo "[INFO] restarting cluster!"

set +o errexit
for idx in 0 1 2
do
    svc="rmq$idx"
    echo "[INFO] svc: $svc"
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmq-upgrade await_online_quorum_plus_one -t 3600
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmq-upgrade await_online_synchronized_mirror -t 3600
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmqctl stop
    docker compose stop "$svc"
    if (( idx < 2 ))
    then
        sleep 10
    fi
    docker compose build --build-arg RABBITMQ_DOCKER_TAG='rabbitmq:3.12-management' "$svc"
    docker compose up --detach --no-deps "$svc"
    sleep 5
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmqctl await_startup
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmq-diagnostics check_port_connectivity
    docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmq-diagnostics check_virtual_hosts
done

docker compose exec --no-TTY "$svc" /opt/rabbitmq/sbin/rabbitmqctl enable_feature_flag all

# "$curdir/import_definitions.sh"
"$curdir/list_vhost_metadata.sh"
