# Etcd

Distributed coordination service, configuration key=value store.

The `Etcd` name means `/etc` distributed.

Alternatives: [Zookeeper](zookeeper.md), [Consul](consul.md)

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Ports](#ports)
- [Docker Quickstart](#docker-quickstart)
- [Install](#install)
- [Confd](#confd)
- [Commands](#commands)
  - [Key-Value Set / Get](#key-value-set--get)
  - [TTL - used to expire a service](#ttl---used-to-expire-a-service)
  - [Watching keys for changes between services](#watching-keys-for-changes-between-services)
  - [waitIndex](#waitindex)

<!-- INDEX_END -->

## Key Points

- distributed Key-Value store
- Raft consensus algorithm
- consistent, fault-tolerant
- Use Cases:
  - config mgmt
  - service discovery
  - coordination (leader election, distributed locks, machine liveness)
- use for metadata (few GBs max)
- global monotonically increasing IDs for consistent ordering
- for big data new NewSQL which has sharding (requires extra coordination for global monotonically increasing ID change)
- used by:
  - CoreOS (Container Linux) - service discovery + shared configuration - locksmith coordinates kernel updates so only subset of cluster is rebooting at one time
  - Kubernetes - service discovery + cluster mgmt (uses Etcd watch API to monitor cluster + roll out config changes)
  - Docker Swarm
  - Mesos
- MVCC - multi-version concurrency control
- higher read/write stability than [ZooKeeper](zookeeper.md)
- reliable key monitoring
- higher level primitives than [ZooKeeper](zookeeper.md) (more like Curator)
- [Consul](consul.md) lower perf but more complete service discovery
  - use Kubernetes instead
- RBAC ([ZooKeeper](zookeeper.md) / [Consul](consul.md) only have ACLs)
- HTTP JSON API
- dynamic membership configuration ([Consul](consul.md) has, [ZooKeeper](zookeeper.md) only in 3.5+)
- configuration stored in WAL - includes cluster member ID, cluster configuration, accessible by all cluster members
- etcd function runs on each cluster's central services role machine
- master election, gracefully handles network partitions and loss of current master
- b+tree - appends only, runs compactions to remove deleted entries
- master database + follower databases
- keys prefixed with `_` are hidden from recursive `GET` requests by default, must explicitly request them
- monotonically incrementing integer for each add / change
- long polling HTTP requests to watch for updates - no way for updates to fall through the cracks like with
  [ZooKeeper](zookeeper.md)

## Ports

| Port   | Description        |
|--------|--------------------|
| 2379   | Client             |
| 2380   | Server-to-Server   |
| 4001   | Client on CoreOS   |

## Docker Quickstart

Quick run in [Docker](docker.md):

```shell
docker run --rm --name etcd -p 2379:2379 quay.io/coreos/etcd:v3.0.15
```

## Install

On Mac, install using [Homebrew](brew.md):

```shell
brew install etcd
```

See the install files:

```shell
$ brew list etcd
/opt/homebrew/Cellar/etcd/3.5.11/bin/etcd
/opt/homebrew/Cellar/etcd/3.5.11/bin/etcdctl
/opt/homebrew/Cellar/etcd/3.5.11/bin/etcdutl
/opt/homebrew/Cellar/etcd/3.5.11/homebrew.etcd.service
/opt/homebrew/Cellar/etcd/3.5.11/homebrew.mxcl.etcd.plist
```

<!--

```shell
mkdir /tmp/etcd
cd /tmp/etcd
ETCD_VER=...
DOWNLOAD_URL=https://github.com/coreos/etcd/releases/download
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-darwin-amd64.zip -o /tmp/etcd-${ETCD_VER}-darwin-amd64.zip
unzip /tmp/etcd-${ETCD_VER}-darwin-amd64.zip -d /usr/local
link_latest /usr/local/etcd-*
```

-->

## Confd

Watches Etcd for specific key / dir changes, `check_cmd`, `reload_cmd`.

```shell
confd -interval 10 -node <host>:<port> /etc/confd/conf.d/my.toml templates/my.tmpl
```

- application containers running on worker nodes with etcd in proxy mode can read and write to an etcd cluster
- common etcd use cases: storing database connection settings, cache settings, shared settings
  - eg. [Vulcand proxy server](http://vulcanproxy.com/) uses etcd to store web host connection details, and it becomes available for all cluster-connected worker machines
  - eg. store database password for MySQL and retrieve it when running an application container

<!--
## CoreOS Essentials
-->

## Commands

### Key-Value Set / Get

```shell
etcdctl set /key1 blah
```

```shell
etcdctl get /key1
```

```shell
etcdctl rm /key1
```

```shell
$ curl -L -X PUT http://127.0.0.1:2379/v2/keys/key2 -d value="blah2"
{"action":"set","key":"/key2","prevValue":"blah","value":"blah2","index":12345}
```

```shell
$ curl -L http://127.0.0.1:2379/v2/keys/key2
{"action":"get","node":{"key":"/key2","value":"blah2","modifiedIndex":12345,"createdIndex":12345}}
```

```shell
curl -L -X DELETE http://127.0.0.1:2379/v2/keys/key2
```

Directories are created automatically when creating a key inside them:

```shell
etcdctl set /myDir/myKey blah
```

```shell
etcdctl ls /myDir --recursive
```

```shell
etcdctl get /myDir/myKey
```

### TTL - used to expire a service

```shell
etcdctl set /myKey "my content" --ttl 30
```

```shell
etcdctl get /myKey
```

```shell
sleep 30
```

```shell
etcdctl get /myKey
```

### Watching keys for changes between services

```shell
etcdctlmkdir /myDir2
```

```shell
etcdctl watch /myDir2 --recursive
```

in another shell:

<!--
cd coreos-vagrant
vagrant ssh
-->

```shell
etcdctl set /myDir2/myKey2 blah2
```

should now see `blah2` in the first window.

### waitIndex

- monotonically incrementing integer for each add / change
- long polling HTTP requests to watch for updates - no way for updates to fall through the cracks like with
  [ZooKeeper](zookeeper.md)

```shell
  curl -L http://host:4001/v2/keys/foo?wait=true[waitIndex=7] # waitIndex = sending our last known index
```

**Ported from private Knowledge Base page 2015+**
