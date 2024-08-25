# ZooKeeper

Coordination and distributed locking service.

Small metadata, watches and locks.

Used by major technologies, especially Big Data technologies like HBase, Hive High Availability, and [SolrCloud](solr.md).

<!-- INDEX_START -->

- [Basics](#basics)
  - [More Details](#more-details)
- [Ports](#ports)
- [Kerberos](#kerberos)
- [CLI](#cli)
- [UI](#ui)
- [Administration](#administration)
- [ZooKeeper 4lw API](#zookeeper-4lw-api)
- [Java API](#java-api)
- [Perl ZooKeeper Client Library - `Net::ZooKeeper` build](#perl-zookeeper-client-library---netzookeeper-build)
- [Monitoring](#monitoring)
- [Multi-DC Availability](#multi-dc-availability)
- [Troubleshooting](#troubleshooting)

<!-- INDEX_END -->

## Basics

- mature, robust, well tested and widely used by HBase, Kafka, SolrCloud, HDFS/Yarn/Hive HA ZKFC, Docker Swarm
- writes need quorum
- reads serviced by node you connect to
- 3 nodes for HA Quorum
- 5 nodes for HA Quorum during maintenance (eg. still HA while taking 1 node down for maintenance)
- 1-4 GB ram
- dedicated disk
- heavy run ZK should be run on separate machines to HBase RegionServers or Hadoop DataNodes, YARN processing nodes
- for HBase make sure to comment out `HBASE_MANAGE_ZK` in `hbase-env.sh`
- network problems often show up first as zookeeper as timeouts / connection problems
- not recommended for virtual environments due to latency

### More Details

- Algorithm is `ZAB` - `ZK Atomic Broadcast`
  - similar to Paxos - requires majority consensus quorum
  - main difference is it only has one promoter at a time
  - stronger focus on total ordering
  - each election then followed by a synchronization phase before new changes accepted
- elected master receives all writes + pushes to slaves in ordered fashion
- slaves also handle read requests + notifications to offload from master
- znode = binary file + directory with version number, rw perms metadata
  - ephemeral - TTL, disappears
  - sequential - auto assigned sequential member suffix by ZK
  - pattern: ephemeral sequential znodes for leader queue where lowest id znode becomes master
- global consistent ordering
- watch on znode:
  - one shot, must re-register watch
  - could lose update to that znode in between receiving + re-registering
  - can detect using version number
  - workaround to use sequential znodes
- atomic update by specifying prev version
  - multiple clients - only one would be successful
  - useful for distributed counters or partial updates of znode data
- batch update API - not as powerful as ACID in RDBMS as no global transaction, must specify pre-state version of each znode
- 1MB znode data limit (but ZK really designed for KB not MB)
  - jute.maxbuffer java setting = message size limit, this limits both data and znode get children
    - needs to be increased for many watchers from a client reconnecting such as with Apache Curator

## Ports

- 2181 - client
- 3181 - quorum
- 4181 - election
- 5181 - client (on MapR)
- 8080 - UI (3.5+)
- 9010 - JMX

## Kerberos

`zoo.cfg` / `zookeeper.properties`:

```properties
authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider
requireClientAuthScheme=sasl
jaasLoginRenew=3600000
```

Pass a JAAS config to ZooKeeper server when starting using this CLI argument:

```none
-Djava.security.auth.login.config=/path/to/zookeeper_jaas.conf
```

## CLI

Wrapper to `zkCli.sh`, convenient as is in `$PATH`:

```shell
zookeeper-client
```

Find and execute `zkCli.sh` from Cloudera install:

```shell
$(find /usr/lib/zookeeper/bin/zkCli.sh /opt/cloudera/parcels -name zkCli.sh -type f | tail -n1)
```

Simpler if on an HBase server:

```hbase
hbase zkcli
```

Logs + snapshots are never cleaned up, so run `zkCleanup.sh`:

```shell
zkCleanup.sh
```

Dump ZooKeeper info:

```shell
echo stat | nc localhost 2181
```

Num ZooKeeper client connections:

```shell
echo cons | nc localhost 2181 | wc -l
```

## UI

- [ZooNavigator](https://zoonavigator.elkozmon.com/en/latest/)
- [Hue ZooKeeper](https://gethue.com/new-zookeeper-browser-app/) browser app

## Administration

Review full ZooKeeper docs:

<https://zookeeper.apache.org/doc/r3.9.1/zookeeperAdmin.html>

zoo.cfg:

```properties
maxClientCnxns
```

## ZooKeeper 4lw API

4 letter word API is a text API on port 2181 you can use via `netcat` or similar.

| Command | Description                                      |
|---------|--------------------------------------------------|
| `ruok`  | returns `isok` if OK                             |
| `isro`  | returns `ro` or `rw` showing if ZK is read-only  |
| `srvr`  | list full details for the server                 |
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

## Java API

Curator is to ZooKeeper what Guava is to Java, written by Netflix

<http://curator.apache.org/>

## Perl ZooKeeper Client Library - `Net::ZooKeeper` build

For [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

```shell
export ZK_TEST_HOSTS=cdh43:2181
```

As the root user, install the C client library.

Get latest version:

```shell
export ZOOKEEPER_VERSION="$(
  curl -sS "https://api.github.com/repos/apache/zookeeper/tags" |
  jq -r '.[].name' |
  grep '[[:digit:]]\.[[:digit:]]' |
  sed 's/^release-//; s/-[[:digit:]]*$//' |
  sort -nr |
  head -n 1
)"
```

```shell
#export ZOOKEEPER_VERSION=3.4.5
wget "http://www.mirrorservice.org/sites/ftp.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz"
tar zxvf "zookeeper-$ZOOKEEPER_VERSION.tar.gz"
cd "zookeeper-$ZOOKEEPER_VERSION/src/c"
./configure
make install
```

Installs headers to `/usr/local/include/zookeeper/zookeeper_version.h`.

Installs objects to `/usr/local/lib/libzookeeper_mt*` and `/usr/local/lib/libzookeeper_st*`.

Install the ZK Perl library:

```shell
cd ../contrib/zkperl
perl Makefile.PL --zookeeper-include=/usr/local/include/zookeeper --zookeeper-lib=/usr/local/lib
LD_RUN_PATH=/usr/local/lib make install
```

`LD_LIBRARY_PATH` considered evil:

- prepends path for everything
- security is an issue
- doesn't work for setuid/setguid programs
- can break applications compatability due to using wrong version of a library

```shell
#export LD_LIBRARY_PATH=/usr/local/lib
perl -e "use Net::ZooKeeper"
```

Could also do:

```shell
cpan
look Net::ZooKeeper
perl Makefile.PL --zookeeper-include=/usr/local/include/zookeeper --zookeeper-lib=/usr/local/lib
make install
```

Uses a C module which needs to be installed so this is pointless:

```shell
#mkdir $github/nagios-plugins/lib/Net
#cp /Library/Perl/5.12/darwin-thread-multi-2level/Net/ZooKeeper $github/nagios-plugins/lib/Net/
```

## Monitoring

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

## Multi-DC Availability

- 3 DC - 2 locally close well connected regions + 1 remote region
- 2 x 2 + 1 remote
- make sure remote never becomes leader
- leader election - each ZK sends it's latest `txid`, others respond yes if theirs is less-or-equal or no, becomes leader if majority say yes
- no way to control leader election priority
- workarounds: start remote ZK last, monitor it with `stat` 4lw API and kill process if it's leader
- this may impact write latency somewhat
- read latency not affected as serviced by the zk node you connect to

## Troubleshooting

If ZK state is bad and it's a dedicated ZooKeeper cluster such as for HBase, to get it all working again:

```shell
mv /var/lib/zookeeper/version-2 /var/lib/zookeeper/version-2.old
mkdir /var/lib/zookeeper/version-2
chown zookeeper:zookeeper /var/lib/zookeeper/version-2
```

Then start ZooKeeper.

## Diagram - ZooKeeper Consensus

![](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/zookeeper.svg)

**Ported from private Knowledge Base page 2012+**
