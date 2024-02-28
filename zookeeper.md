# ZooKeeper

Coordination and distributed locking service.

Small metadata, watches and locks.

Used by major technologies, especially Big Data technologies like HBase, Hive High Availability, and [SolrCloud](solr.md).

### Basics

- 3 nodes for HA Quorum
- 5 nodes for HA Quorum + maintenance ability
- 1-4 GB ram
- dedicated disk
- heavy run ZK should be run on separate machines to HBase RegionServers or Hadoop DataNodes, YARN processing nodes
- for HBase make sure to comment out HBASE_MANAGE_ZK in `hbase-env.sh`
- network problems often show up first as zookeeper as timeouts / connection problems

### Ports

- 2181 - client
- 3181 - quorum
- 4181 - election
- 5181 - client (on MapR)
- 8080 - UI (3.5+)
- 9010 - JMX

### Kerberos

`zoo.cfg` / `zookeeper.properties`:
```
authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider
requireClientAuthScheme=sasl
jaasLoginRenew=3600000
```

Then pass a JAAS config to ZooKeeper server when starting using this CLI argument:
```
-Djava.security.auth.login.config=/path/to/zookeeper_jaas.conf
```

### ZooKeeper 4lw API

4 letter word API is a text API you can use via `netcat` or similar

| Command | Description                                      |
|---------|--------------------------------------------------|
| `ruok`  | returns `isok` if OK                             |
| `isro`  | returns `ro` or `rw` showing if ZK is read-only  |
| `srvr`  |                                                  |
| `stat`  | same as srvr + cons                              |
| `mntr`  | fuller stats dump, one per line, no client conns |
| `envi`  | show zookeeper environment                       |
| `conf`  | prints the `zoo.cfg` config                      |
| `cons`  | show client conns                                |
| `srst`  | reset server stats                               |
| `crst`  | reset connection stats                           |
| `wchs`  | summary of server's watches                      |
| `wchc`  | watches by connection                            |
| `wchp`  | watches by path                                  |

### Java API

Curator is to ZooKeeper what Guava is to Java, written by Netflix

http://curator.apache.org/

###### Partial port from private Knowledge Base page 2012+
