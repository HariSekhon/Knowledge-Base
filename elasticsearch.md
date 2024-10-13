# Elasticsearch

NOT PORTED YET

Distributed ring clustered search service.

<!-- INDEX_START -->

- [Sample Sizing](#sample-sizing)
- [Docker Quickstart](#docker-quickstart)
- [Heap](#heap)
- [Linux Limits](#linux-limits)
- [Monitoring](#monitoring)
- [Performance Tuning Tips](#performance-tuning-tips)
- [Diagram](#diagram)
  - [Elasticsearch Queries](#elasticsearch-queries)
- [Elasticsearch on Kubernetes](#elasticsearch-on-kubernetes)
- [Bulk Indexing from Hadoop MapReduce (Pig) - Performance](#bulk-indexing-from-hadoop-mapreduce-pig---performance)
- [Client Libaries](#client-libaries)

<!-- INDEX_END -->

## Sample Sizing

Cluster from a bank: 470TB 88 nodes 30k events/sec

## Docker Quickstart

```shell
docker run --rm --network host -p 9200:9200 elasticsearch
```

X-Pack 30 days trial with authentication:

```shell
docker run --rm --network host -p 9200:9200 -e ELASTIC_PASSWORD=password docker.elastic.co/elasticsearch/elasticsearch-platinum:6.2.2
```

## Heap

Used 30% of 6 nodes at 10g, increased to 75% with 30g, odd failed task retried, some dups.

/etc/sysconfig/elasticsearch:

```text
ES_HEAP_SIZE=30g # was doing Full GCs at 10g
```

Get rid of stupid Marvel superhero names for easier debugging, export HOSTNAME for use in elasticsearch.yml:

```shell
export HOSTNAME=$(hostname -s)
```

## Linux Limits

To allow `mlockall: true` to work in elasticsearch config:

/etc/security/limits.d/elasticsearch:

```text
* - memlock unlimited
* - nproc 5000
* - nofile 32000
```

## Monitoring

- Marvel

- [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Nagios-Plugins&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Nagios-Plugins)

## Performance Tuning Tips

Single tenant dedicated servers more appropriate for Elasticsearch workloads.

- 600-750 shards per node max per 30GB instance, best <= 500
- shard max = 50GB (bigger makes replication slower)
- too much data = slow recovery shard migration (2-2.5h for 5TB nodes!!)

Segregate roles for best performance:

- master node - manages shard routing table + distributes to nodes - send cluster health checks here
- data node   - stores data + fullfils queries - send writes here
- client node - non-master non-data handles merge-sort (CPU + RAM intensive) aggregation from distributed shard queries to data nodes - point LBs + send queries to client nodes

[Cluster update settings API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-update-settings.html)

## Diagram

### Elasticsearch Queries

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

![Elasticsearch Queries](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/elasticsearch_queries.svg)

## Elasticsearch on Kubernetes

In tests Elasticsearch performance on Kubernetes was significantly lower than on bare metal servers.

This is to be expected, due to both virtualization and lower spec disk storage.

If trying to use over-spec'd servers while avoiding large heap JVM issues by running multiple Elasticsearch
instances on same host, set this to check not all shard replicas go on same host:

```properties
cluster.routing.allocation.same_shard.host = true
```

- query:
  - node (becomes query gateway node)
    - `node2` returns top 10
    - `node3` returns top 10

Gateway node does merge-sort (CPU + RAM intensive) - this should mean that theoretically it doesn't scale quite
linearly because of gateway node's merge-sort = more nodes = more overhead

## Bulk Indexing from Hadoop MapReduce (Pig) - Performance

14.5B docs, 18TB data across 6 high spec servers

- data spread was not even across nodes
- Linux `load` command shows uneven load across nodes during bulk insertions from
  [Pig](https://github.com/HariSekhon/DevOps-Python-tools/blob/master/pig-text-to-elasticsearch.pig)

Dynamic settings per index:

```properties
index.refresh_interval: -1
index.number_of_replicas: 0
```

10GigE - increase recovery speed - PUT /_cluster/setting into persistent

```properties
indices.recovery.max_bytes_per_sec = '400mb'
```

Files of shard are spread across disks like Raid 0 - this will change to one data path per shard in Elasticsearch 2.0

- `path.data` - 3 disks or 1 disk similar very high CPU 800-2000%, went back to using 12 disks to at least spread the
                I/O and stop raising dozens % I/O on the fewer disks

## Client Libaries

The Java Elasticsearch client that is routing table aware to skip one hop, equivalent to a client-side Load
Balancer. Use this instead of a Load Balancer as it's more efficient 1 less level of network indirection.

Perl CPAN [Search::Elasticsearch](https://metacpan.org/pod/Search::Elasticsearch)

**Partial port from private Knowledge Base page 2013+**
