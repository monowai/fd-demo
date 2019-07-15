
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

```$bash
docker run -it -e spring.rabbit.host=rabbit -e org.fd.engine.api=http://fd-engine:15001 --network=fd-demo_default flockdata/fd-shell
// Verify connectivity
fd-shell$ ping
pong
```

Check your credentials with the `demo` account. User demo:123 is the default configured account as set in docker-compose.yml
`fd-shell$ login --user demo --pass 123`

Check that inter-service connectivity is established.
```
health
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

## Use the UI
At this point you can login to [fd-view](http://localhost:15000) use demo/123 for credentials. You will be asked to register your account as a data access user in order to write data to the service.

Search and store have unsecured endpoints. fd-engine talks to them

fd-search

`curl http://localhost:15002/api/ping`

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

## Security

FlockData uses configurable [security mechanisms](https://github.com/monowai/flockdata.org/tree/master/fd-security) backed by the Spring Security framework. We love [StormPath](http://stormpath.com); you might too.
This stack uses simple security credentials that are managed in the `docker-compose.yml` file. Namely a single set of credentials - `demo` / `123`

FlockData currently has two access roles:

|Role|Purpose|
|---|---|
|FD_ADMIN|Allows performing administrative functions and creating data access users|
|FD_USER|Allows user accounts access to the service. Should be registered to connect to a SystemUser account that authorises reading and writing of data|

Authorised users are accounts that exist in your security domain. Authorised users need to have a FlockData SystemUser identity established. 

Security roles are defined in your authorisation sub-system - LDAP/AD/StormPath etc. They are not stored in FlockData (except in the case of using the simpleauth security mechanism).    

SystemUser identify
    Authenticated accounts need to be connected to a system user account to read and write data. This is done via the RegistrationEP or using the flockdata/fd-client docker image

## Registering a SystemUser account
This example logs in as an FD_ADMIN account - `demo` - and creates a SystemUser identify for the login identifier `demo` i.e. it connects the auth account to a SystemUser data access account. You can do this in one of the two following ways:

Using the pre-configured fd-client container in the docker-compose stack

```
fdregister -u=demo:123 -l=demo -c=flockdata
```

With the data access account established, you can load some static data into the service. FlockData comes with a data set of countries and capitals. Load this data via the following command    

```
ingest --data "./data/fd-cow.txt,./model/countries.json;./data/states.csv,./model/states.json"
```

You can now navigate to the [Neo4j browser](http://localhost:7474) and after logging in with default password of `neo4j` you can run the following Cypher

`match (c:Country) return c` 

## Tracking data in to the service

Other commands that track data in to the service can be found [here](https://github.com/monowai/flockdata.org/tree/master/fd-engine#interacting-with-flockdata)

