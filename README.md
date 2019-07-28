
Starts the [FlockData](http://FlockData.com) stack with Docker Compose

## Status
Docker and docker-compose is the only current pre-packaged distribution. Pre-built artifacts are available in the [MVNRepostitory](https://mvnrepository.com/artifact/org.flockdata) for alternative deployment scenarios 

You'll need to ensure you have a recent version of Docker installed 17.12+

We are assuming you are not using docker-toolbox but rather Docker for Windows/Mac etc

# Installation

## Step 1 - Clone this repo
`git clone https://github.com/monowai/fd-demo`

`cd fd-demo`

## Step 2 Start the services
`docker-compose up -d` This will take time to pull images from the docker hub

Congratulations - you've now installed started ElasticSearch, Neo4j, Riak, RabbitMQ, FdEngine, FdSearch, FdStore, FdDiscovery and a bunch of other useful apps 

# Testing the install
This stack runs in the fd-demo_default network.

fd-shell is the most useful way to verify connectivity which encapsulates most calls to the REST api for convenience

Default login account is demo password is 123 this is configured in docker-compose.yml

```$bash
# Start the shell
docker run --name fddemo-fdshell -it -e spring.rabbitmq.host=rabbit -e org.fd.engine.api=http://fd-engine:15001 --network=fd-demo_default flockdata/fd-shell
# Verify connectivity
fd-shell$ ping
pong
fd-shell$ login demo
password: ***
{
  "login" : "demo",
  "name" : "demo",
  "companyName" : "flockdata",
  "apiKey" : <somekey>,
  "email" : null,
  "status" : "ENABLED",
  "userRoles" : [ "ROLE_FD_ADMIN", "ROLE_FD_USER", "ROLE_USER" ],
  "active" : true
}
# Check that inter-service connectivity is established.

fd-shell$ health
{
  "eureka.client.serviceUrl.defaultZone" : "http://eureka:8761/eureka/",
  "fd-search" : {
    "org.fd.search.api" : "http://fd-search:15002",
    "status" : "!Unreachable fd-search"
  },
  "fd-store" : {
    "org.fd.store.api" : "http://fd-store:15003",
    "fd.store.engine" : "RIAK",
    "fd.store.enabled" : "true",
    "status" : "OK - Riak"
  },
  "fd.version" : "0.98.9-SNAPSHOT (master/4af8049)",
  "rabbit.host" : "rabbit",
  "rabbit.port" : "5672",
  "rabbit.user" : "guest",
  "spring.cloud.config.discovery.enabled" : "false"
}
```

## FD-VIEW
You can login to [fd-view](http://localhost:9000) using the above  credentials.

## Packaged services
|Service   |Description   |Address   |
|---|---|---|
|[fd-view](https://github.com/monowai/fd-view) |FlockData's integrated browser and analysis tool   |[http://localhost](http://localhost)|
|[weavescope](https://www.weave.works/products/weave-scope/)|visual overview of the stack   |[http://localhost:4040](http://localhost:4040)|
|RabbitMQ |messaging admin|[http://localhost:15672](http://localhost:15672)|
|[ElasticSearch](https://www.elastic.co)|Rest based search API |[http://localhost:9200](http://localhost:9200)|
[neo4j-browser](http://neo4j.org)|HTML graph browser and REST access to Neo4j|[http://localhost:7474](http://localhost:7474)|
[Kibana](https://www.elastic.co/products/kibana)|ElasticSearch data viz|[http://localhost:5601](http://localhost:5601)|
|Spring/Netflix Eureaka|Monitoring|[http://localhost:8761](http://localhost:8761)|
|[PostMan](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en)|Documentation for the REST API|[Postman](https://github.com/monowai/flockdata.org/blob/master/fd.api-postman.json)|


## Loading country data
With your demo account registered as a data access user, you can register
```
register --account demo --email demo@flockdata.com --company flockdata
```

With the data access account established, you can load some static data into the service. FlockData comes with a data set of countries and capitals. Load this data via the following command    

```
ingest --data "./data/fd-cow.txt,./model/countries.json;./data/states.csv,./model/states.json"
```

You can now navigate to the [Neo4j browser](http://localhost:7474) and after logging in with default password of `neo4j` you can run the following Cypher

`match (c:Country) return c` 

## Tracking data in to the service

Other commands that track data in to the service can be found [here](https://github.com/monowai/flockdata.org/tree/master/fd-engine#interacting-with-flockdata)

