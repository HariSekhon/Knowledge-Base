# ZooKeeper

Coordination and distributed locking service.

Small metadata, watches and locks.

Used by major technologies, especially Big Data technologies like HBase, Hive High Availability, and [SolrCloud](solr.md).

## Basics

- 3 nodes for HA Quorum
- 5 nodes for HA Quorum + maintenance ability
- 1-4 GB ram
- dedicated disk
- heavy run ZK should be run on separate machines to HBase RegionServers or Hadoop DataNodes, YARN processing nodes
- for HBase make sure to comment out HBASE_MANAGE_ZK in `hbase-env.sh`
- network problems often show up first as zookeeper as timeouts / connection problems

## Ports

- 2181 - client
- 3181 - quorum
- 4181 - election
- 5181 - client (on MapR)
- 8080 - UI (3.5+)
- 9010 - JMX

## Kerberos

`zoo.cfg` / `zookeeper.properties`:
```
authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider
requireClientAuthScheme=sasl
jaasLoginRenew=3600000
```

Pass a JAAS config to ZooKeeper server when starting using this CLI argument:

```
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

https://zookeeper.apache.org/doc/r3.9.1/zookeeperAdmin.html

zoo.cfg:
```shell
maxClientCnxns
```

## ZooKeeper 4lw API

4 letter word API is a text API on port 2181 you can use via `netcat` or similar.

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

## Java API

Curator is to ZooKeeper what Guava is to Java, written by Netflix

http://curator.apache.org/


## Perl ZooKeeper Client Library - `Net::ZooKeeper` build

For [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

```shell
export ZK_TEST_HOSTS=cdh43:2181
```

As the root user, install the C client library:

```shell
# install C client library
export ZOOKEEPER_VERSION=3.4.5
wget http://www.mirrorservice.org/sites/ftp.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
tar zxvf zookeeper-$ZOOKEEPER_VERSION.tar.gz
cd zookeeper-$ZOOKEEPER_VERSION/src/c
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


###### Partial port from private Knowledge Base page 2012+
