#!/usr/bin/env bash

set -o errexit
set -o nounset

curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly curdir

echo "[INFO] importing definitions into rmq0..."

docker compose cp "$curdir/tmp/defs.json" rmq0:/tmp
docker compose exec --no-TTY rmq0 rabbitmqctl import_definitions /tmp/defs.json
