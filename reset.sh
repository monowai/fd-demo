#!/usr/bin/env bash
docker stop  $(docker ps --format '{{.ID}}' )
docker volume rm fd-riak
docker volume rm fd-es
docker volume rm fd-neo


#docker rm $(docker ps -a -q)
#docker rmi $(docker images -q -f dangling=true)
