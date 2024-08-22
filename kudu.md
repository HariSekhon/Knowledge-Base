# Kudu

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Install](#install)
- [Login](#login)

<!-- INDEX_END -->

## Key Points

- Cloudera
- C++
- columnar
- fixed number of shards (must copy out to change)
- designed for simultaneous sequential + random reads/writes
- strong consistency
- tablet leaders serve writes
- read-only replicas
- tablet replicas = leaders, candidates (to become leaders), followers
- write requires consensus among replicas
- Raft consensus algorithm for leader elections among replica per tablet
- design similar to HBase
- tablet server == RegionServer
- tablet == region
- one Master elected:
  - tracks tablets + tablet servers
  - catalog table + metadata
  - triggers re-replication
  - client -> master for DDL
  - master writes table metadata
  - master allocates tablets on TabletServers
- Master's own data stored in a tablet replicated to other candidate masters
- TabletServers heartbeat to Master - default interval every 1 sec
- Catalog Table - all metadata - table schema, tablet locations, tablet state, tablet servers holding replicas, tablet start-stop key ranges
- each tablet 3 or 5 replicas for RAF algo
- integration with Spark, MR, Impala
  - Drill (in progress by Dremio)
- ODS - operational data store - updates + queries
- client asks master for tablet locations + caches it
- metadata cached in RAM for performance
- range partition for native hash partitions of primary key
- Kudu slightly faster than Parquet when data is in RAM, 2x slower from disk
- tablet leader failure auto re-election ~5 secs
- < 5 min down transparent rejoin
- \> 5 min down new failover replica created + data copied
- heartbeats between tablet replicas
- strong reads require reading from leader
- called Kudu because the antelope has stripes like columnar DB
- Insert -> MemRowSet + WAL, flushed later
- Updates -> "delta store" -> flush to delta files on disk
- delta files eventually compacted to columnar data files
- handles all the view merging behavious for you
- single-row ACID
- high throughput within 2x of Parquet
- low latency 1ms read/write on SSD
- fixed SQL-like schema
- handles late data + corrections with ease
- new data immediately available for analytics
- can run without HDFS
- master serers are seeds
- replication of logical operations, not data on disk
- compaction:
  - no data transmitted over network
  - less network traffic for write heavy scenarios

- tested 275 nodes 3PB
- millions of read/write ops per sec

## Install

```shell
curl http://archive.cloudera.com/beta/kudu/redhat/6/x86_64/kudu/cloudera-kudu.repo > /etc/yum.repos.d/cloudera-kudu.repo
```

NTP required to avoid clock unsynchronized error msgs

```shell
yum install -y ntp
yum install -y kudu
yum install -y kudu-master
yum install -y kudu-tserver
yum install -y kudu-client0
yum install -y kudu-client-devel
```

Doesn't work in Docker, trying instead:

```shell
curl -s https://raw.githubusercontent.com/cloudera/kudu-examples/master/demo-vm-setup/bootstrap.sh | bash
```

## Login

demo/demo

**Ported from private Knowledge Base pages 2016+**
