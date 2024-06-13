#!/usr/bin/env bash

set -o errexit
set -o nounset

curdir="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
readonly curdir

echo "[INFO] exporting definitions from rmq0..."

mkdir -p "$curdir/tmp" || true
docker compose exec --no-TTY rmq0 rabbitmqctl export_definitions - | jq '.' > "$curdir/tmp/defs.json"
