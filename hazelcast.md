# HazelCast

<https://hazelcast.com/products>

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Code](#code)

<!-- INDEX_END -->

## Key Points

- In-Memory Data Grid
- Apache licensed open source
- HA, scale out, resilient
- hash-mod partitioning on the key with replicas (XXX: what about list partitioning, data skew etc?)
- compact library < 3MB with no deps
- distributed Java collections (map/set), caching, session state sharing,
- distributed locks, queues, topics
- x10 faster than Cassandra
- Memcache
- dynamic discovery (multicast) or TCP list, ZooKeeper, Consul, etcd
- Management Center 2 nodes open source, rest Basic subscription upwards
- WAN replication in Enterprise only
- REST + JMX API per node
- Clustered REST + JMX only in Enterprise
- Java client - C#/C++ in Enterprise
- Enterprise 7k, Professional 4k, Basic 2.5k dollars, Open Source

- Hazelcast founded in 2008, 75 staff inc 30 engineers
- In Memory Data Storage (TBs, not PBs)
- In Memory Data Messaging (pub/sub)
- In Memory Data Computing
- JCache Provider (JCP) - vendor neutral cache API like JDBC for databases

- Hazelcast Simulator on Github for provisioning and running stress tests, benchmarking etc

Compute - can run function on every node or select nodes

- Pub-Sub - has ringbuffer to allocate slow/disconnected consumers to catch up
          - ringbuffer size is configurable, can overwrite or block

3.6 will have a disk restart option

## Code

```shell
HazelcastInstance hazelcastInstance = Hazelcast.newHazelcastInstance();
```

Client only connection not part of cluster memory:

```shell
HazelcastInstance hazelcastInstance = HazelcastClient.newHazelcastClient();
```

**Ported from private Knowledge Base page 2014+**
