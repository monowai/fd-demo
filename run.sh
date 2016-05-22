#!/usr/bin/env bash
docker volume create --name=fd-riak
docker volume create --name=fd-es
docker volume create --name=fd-neo
docker-compose up -d

