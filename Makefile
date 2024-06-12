.PHONY: clean down up perms rmq-perms export-definitions

DOCKER_FRESH ?= false
RABBITMQ_DOCKER_TAG ?= rabbitmq:3.11.28-management

clean: perms
	git clean -xffd

down:
	docker compose down

up: rmq-perms
ifeq ($(DOCKER_FRESH),true)
	docker compose build --no-cache --pull --build-arg RABBITMQ_DOCKER_TAG=$(RABBITMQ_DOCKER_TAG)
	docker compose up --pull always
else
	docker compose build --build-arg RABBITMQ_DOCKER_TAG=$(RABBITMQ_DOCKER_TAG)
	docker compose up
endif

perms:
	sudo chown -R "$$(id -u):$$(id -g)" data log

rmq-perms:
	sudo chown -R '999:999' data log

export-definitions:
	mkdir -p $(CURDIR)/tmp || true
	docker compose exec --no-TTY rmq0 rabbitmqctl export_definitions - | jq '.' > $(CURDIR)/tmp/defs.json

import-definitions:
	cat $(CURDIR)/tmp/defs.json | docker compose exec --no-TTY rmq0 rabbitmqctl import_definitions
