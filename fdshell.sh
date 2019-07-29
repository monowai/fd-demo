#!/bin/bash

container_name=fddemo-fdshell
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${container_name}\$"; then
  docker rm ${container_name}
fi
docker run --name fddemo-fdshell -it -e spring.rabbitmq.host=rabbit -e org.fd.engine.api=http://fd-engine:15001 --network=fd-demo_default flockdata/fd-shell



