
Starts the [FlockData](http://FlockData.com) stack with Docker Compose

## Status
Docker and docker-compose is the only current distribution. Contact us if you require an AWS image.

## Pre-requisite
Docker and docker compose  - aka [DockerToolbox](https://www.docker.com/products/docker-toolbox). Do not run this with the docker osx/windows beta as underlying community libraries are still being upgraded to address the new architecture.

Make sure you docker-machine is up and running

`docker-machine ip`

# Docker-Compose Install

## Clone this repo
`git clone https://github.com/monowai/fd-demo`

`cd fd-demo`

## Create volumes
Each FlockData service writes data to a named volume that we will now establish - stateful data resides here. Data will likely be removed if you run docker cleanup scripts but will persist between restarts of the docker-machine

`docker volume create --name=fd-neo`

`docker volume create --name=fd-es`

`docker volume create --name=fd-riak`


With the volumes created, start up the services. Give things about 30 seconds to complete spinning up.

`docker-compose up -d`

FlockData has a configurable security meachaism backed by the Spring Security framework. We love [StormPath](http://stormpath.com); you might too.
This stack uses simple security credentials that are managed in the `docker-compose.yml` file. Namely a single set of credentials - `demo` / `123`

# Testing the install
This stack runs in the docker-machine. If you're not running on native linux, then you will need to replace `docker-ip` with your docker-machine IP address. You might want to create a `hosts` file entry.

See who you are
`curl -u demo:123 http://docker-ip:8080/api/account`

Check that inter-service connectivity is esablished
`curl -u demo:123 http://docker-ip:8080/api/v1/admin/health`

You should see a result something like this:
```{
  "eureka.client.serviceUrl.defaultZone" : "http://eureka:8761/eureka/",
  "fd-search" : "Ok on http://fd-search:8081",
  "fd-store" : "Ok on http://fd-store:8082",
  "fd.store.enabled" : "false",
  "fd.store.engine" : "RIAK",
  "fd.version" : "0.98.1a (v0.98.1a/454008f)",
  "rabbit.host" : "rabbit",
  "rabbit.port" : "5672",
  "rabbit.user" : "guest",
  "spring.cloud.config.discovery.enabled" : "false"
}
```

## Say hello
fd-engine       `curl -u demo:123 http://docker-ip:8080/info`

Search and store have unsecured endpoints. fd-engine talks to them

fd-search       `curl http://docker-ip:8081/api/ping`

fd-store        `curl http://docker-ip:8082/api/ping`

Riak            `curl http://docker-ip:8082/api/v1/admin/ping/riak` (Verify fd-store connectivity to Riak)

## Tracking data in to the service

Example commands that track data in to the sevice can be found [here](https://github.com/monowai/flockdata.org/tree/master/fd-engine#interacting-with-flockdata)

## User Interfaces

fd-view         coming soon

RabbitMQ        `http://docker-ip:15672` (HTML queue admin)

[ElasticSearch](https://www.elastic.co)   `curl http://docker-ip:9200` (REST API)

neo4j-browser   http://docker-ip:7474  (HTML browser and REST access to Neo4j)

[Kibana](https://www.elastic.co/products/kibana)          http://docker-ip:5601 (ElasticSearch data viz)

Spring Eureaka  http://docker-ip:8888

FlockData's API documentation is managed in postman, a google chrome app. Modify the environment settings, in Postman, to point to your `docker-ip` as appropriate.

[Postman](https://github.com/monowai/flockdata.org/blob/master/fd.api-postman.json)
