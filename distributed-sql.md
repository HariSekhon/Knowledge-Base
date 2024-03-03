# Distributed SQL

SQL based databases that scale horizontally.

## Hive

See [hive.md](hive.md)

## Impala

See [impala.md](impala.md)

## Apache Drill

See [apache-drill.md](drill.md)

## CrateDB

https://cratedb.com/

- open source
- distributed SQL database
- built on Lucene + Elasticsearch (as a library for cluster state, node discovery/mgmt, sharding + replication)
- masterless
- shared nothing
- good for containers
- dynamic schemas
- uses Presto's optimizer
- no ACID or relational
- full-text search via Lucene
- faster properly distributed aggregations than Elasticsearch
- JOINs unlike Cassandra
