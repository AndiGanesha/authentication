SHELL := /bin/bash

# Golang Stuff
GOCMD=go
GORUN=$(GOCMD) run
ARGS=$(filter-out $@,$(MAKECMDGOALS))

# Database stuff
POSTGREQSQL_URL="$(DB_DRIVER)://$(DB_USER):$(DB_PASSWORD)@$(DB_HOST):$(DB_PORT)/$(DB_NAME)?sslmode=disable&search_path$(DB_SCHEMA)"

build:
	go build -o bin/main main.go

run:
	export GOSUMDB=off
	set -o allexport; source config/local.env; set +o allexport && ${GORUN} main.go ${ARGS}

mock: #run with -B
	./mock/script.sh
	$(GOCMD) generate ./...

lint: 
	golangci-lint run --deadline=30m

test:
	export GOSUMDB=off
	$(GOCMD) test ./...