# Confluent

<https://www.confluent.io/>

Confluent Platform - Kafka-based platform

- Connectors for:
  - ActiveMQ
  - IBM MQ
- Schema Registry
- dates in UTC
- Avro / Parquet data long epoch
- custom `YYYY-MM-DD HH:MM` 24hr (it's string sortable)
- just use Avro for all general purpose data
- command line tools for converting Json <-> Avro messages
- version 4.1 - adds cross DC replication

## Kafka Streams

- Kafka Streams = Java lib for event based processing in functional style 0.10 onwards
- not analytics but microservices + core services

## KSQL - Kafka SQL

<https://www.confluent.io/blog/ksql-streaming-sql-for-apache-kafka/>

## Camus

- Camus = MR job batch dumps Kafka topic to Hadoop
- auto topic discovery
- avro schema mgmt + Schema Registry
- output partitioning on timestamp

```shell
bin/camus -run -D schema.registry.url=http://host:8081 -P etc/camus/camus.properties
```

## Kafka REST Server

<https://docs.confluent.io/platform/current/kafka-rest/index.html>

- `/topics` - list topics
- `/topic/mytopic` - info on topic
- `/partitions` - info on topic partitions

## Schema Registry

- named, versioned schemas
- schema evolution following Avro rules (registy will validate schema compatibility)
- unify upstream + downstream
- resilient data pipelines, upstream won't send data downstream can't handle
- downstream can get alerted on schema changes in registy
- discovery
- efficiency, don't have to store names with data

- Kafka schema registry serializer auto populates Registry schema when sending Avro objects in Producer

- REST API
- 10,000 schemas ~ 1GB RAM
- In-RAM indices for fast lookup
- Storage = Kafka topic "_schema"
- Active / Standby HA - ZK ephemeral znode `/<schema.registry.zk.namespace>/schema_registry_master`
- first server to claim znode wins + becomes active

JVM settings (from Confluent deployment doc)

```
-Xms1g -Xmx1g -XX:PermSize=48m -XX:MaxPermSize=48m -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitializingHeapOccupancyPercent=35
```

##### Ported from private knowledge base page 2016+
