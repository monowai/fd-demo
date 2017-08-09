#!/usr/bin/env bash
docker stop  $(docker ps --format '{{.ID}}' )
docker volume rm fddemo_fd-riak
docker volume rm fddemo_fd-es
docker volume rm fddemo_fd-neo


#docker rm $(docker ps -a -q)
#docker rmi $(docker images -q -f dangling=true)
