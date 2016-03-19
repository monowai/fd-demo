
Starts the [FlockData](http://FlockData.com) stack with Docker Compose

## Pre-requisite
Docker and docker compose

An AMI image with docker & compose is available which you can launch this by locating ami-e0999a8a in the AWS store

## Grabbing the FlockData compose script
`git clone https://github.com/monowai/fd-demo`
`cd fd-demo`

## Create volumes
Each FlockData service writes data to a name volume that you define. For demo purposes you can crate the following:

`docker volume create --name=fd-neo`
`docker volume create --name=fd-es`
`docker volume create --name=fd-riak`

With the volumes created, bring up the services and give things about 30 seconds to complete spinning up.
`docker-compose up -d`

verify connectivity using the demo credentials of 'mike' and password '123'
`curl -u mike http://localhost:8080/api/v1/profiles/me`

## Postman
The API can be invoked via postman. Modify the environment settings, in Postman, to point to your Docker host
[Postman](https://github.com/monowai/flockdata.org/blob/master/fd.api-postman.json)

Note that you will need to setup a proxy server to handle requests from outside of localhost

## Whats installed?

fd-engine       http://locahost:8080
fd-search       http://locahost:8081
fd-store        http://locahost:8082
RabbitMQ        http://localhost:15672
ElasticSearch   http://localhost:9200
Riak
neo4j-browser   http://localhost:7474
Kibana          http://locahost:5601
Spring Eureaka  http://locahost:8888