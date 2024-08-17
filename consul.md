# Consul

<!-- INDEX_START -->
- [Summary](#summary)
- [Ports](#ports)
- [Consul vs ZooKeeper / Doozerd / SkyDNS / SmartStack](#consul-vs-zookeeper--doozerd--skydns--smartstack)
- [Install](#install)
- [Options](#options)
- [Run](#run)
- [Cluster](#cluster)
- [Maintenance](#maintenance)
- [API](#api)
- [Services](#services)
  - [HTTP API](#http-api)
  - [DNS API](#dns-api)
- [Multi-DC](#multi-dc)
- [Cluster test](#cluster-test)
- [Health Checks](#health-checks)
- [Key Value Store](#key-value-store)
- [UI](#ui)
<!-- INDEX_END -->

## Summary

Passed the [Jepsen](https://jepsen.io/) test!!! (most technologies fail it)

- service level
- service discovery framework
- strongly consistent
- CP from CAP - needs quorum
- gossip protocol
- health checks
- agents on each server support more complex health checks
- HTTP + DNS APIs
- K/V hierarchical storage for conf / leader election / long poll conf watching, feature flagging
- multi-DC support (runs multiple gossip protocols to not degrade perf, clients query local DC)
- use 5 consul servers in each DC for quorum and ability to lose 2 nodes, resilience during rolling restarts etc
- agent on every node
- Ctrl-C agent => graceful leave - otherwise marks as failed and retries
- servers fail/non-graceful can affect quorum!
- query any server or agent (fwds to servers)
- locking semantics heavily borrowed from Google's Chubby design
- data uses consensus (strongly consistent)
- event data purely P2P gossip, no guarantee, no global ordering
- event data should be < 100 bytes

## Ports

| Port   | Description |
|--------|-------------|
| 8500   | HTTP API    |
| 8600   | DNS API     |
| 8400   | RPC         |
| -1     | HTTPS       |

## Consul vs ZooKeeper / Doozerd / SkyDNS / SmartStack

- all quorum, CP no A strongly consistent
- service framework for service discovery vs just KV build your own
- health checks vs just coarse TTL based agent liveness
- peer-to-peer discovery
- tags for querying
- distributed health checks like Sensu
- single cohesive architecture (SmartStack uses ZooKeeper)
- sends only changes, less traffic for steady state
- Doozerd uses Paxos consensus algo & Protocol Buffers, written by Heroku
- Etcd uses Raft (simpler), Etcd + Doozerd written in Go
- Etcd has rolling upgrades, ZooKeeper added this later (2014?)

Industrial Light and Magic used Consul because Mesos DNS couldn't easily register docker containers outside Mesos
cluster.

## Install

```shell
brew install caskroom/cask/brew-cask
```

```shell
brew cask install consul
```

## Options

```shell
consul --help
```

common opts

```none
-rpc-addr 127.0.0.1:8400
```

```none
-config-dir searches for .json files
```

```none
-config-file / -config-dir can be specified multiple times
```

```none
consul configtest [ -config-file <file> ] [ -config-dir <dir> ]
```

## Run

Start a single node non-production non-persistent:

```shell
consul agent -dev
```

```none
-node myName set node name explicitly (if hostname has a dot DNS queries won't work)
```

Will complain if there are multiple interfaces to configure one - using Docker interface:

```shell
consul agent -dev -bind 192.168.99.1
```

```shell
consul info
```

## Cluster

```shell
consul join <node>
```

```shell
consul force-leave <node>
```

```shell
consul leave
```

Eventually consistent information - use HTTP API on consul servers for strongly consistent info
optional:

```none
-status <regex>   - filter
-wan              - show server nodes participating in WAN gossip protocol
```

```shell
consul members
```

```none
Node           Address            Status  Type    Build  Protocol  DC
agrippa.local  192.168.99.1:8301  alive   server  0.6.1  2         dc1
```

```shell
consul members -detailed
```

```none
Node           Address            Status  Tags
agrippa.local  192.168.99.1:8301  alive   build=0.6.1:68969ce5,dc=dc1,port=8300,role=consul,vsn=2,vsn_max=3,vsn_min=1
```

```
-http-addr
-datacenter       defaults to same as agent
-node <regex>     filter
-service <regex>  filter
-tag  <regex>     filter
-verbose
```

```shell
consul exec <cmd>
```

```shell
consul event -name blah [ <payload> ]
```

```none
[ -datacenter dc2 ] default: local dc
[ -node <regex> ]
[ -service <regex> ]
[ -tag <regex> ]
[ -token <auth_token> ]
```

optional opts:

```none
-n 1          default: 1 - number of concurrent processes that can run on the given lock
--name        default: generated from <cmd>
-pass-stdin   default: stdin to feed to <cmd>
-try          give up if lock not acquired within X time, units = ns, us, ms, s, m, h
-verbose
```

```shell
consul lock [opts] <lock_key_prefix> <cmd>
```

```shell
consul watch
```

```none
-log-level=info   warn, err, debug, trace
-rpc-addr=127.0.0.1:8400
```

## Maintenance

Connect to an agent and follow it's logs:

```shell
consul monitor
```

Reload config file - errors only show in agent log - same as `kill -HUP`:

```shell
consul reload
```

Print list of maintenances:

```shell
consul maint
```

Drop service/node out of pool of results - drops node if -service not given:

```shell
consul maint -enable/-disable [-service <id>] [-reason <msg>]
```

```shell
consul keyring -list -install/-use/-remove
```

## API

HTTP API node query:

```shell
curl localhost:8500/v1/catalog/nodes
```

```json
[{"Node":"agrippa.local","Address":"192.168.99.1","CreateIndex":3,"ModifyIndex":4}]
```

DNS API node query - `NAME.node.consul` or `NAME.node.DATACENTER.consul`:

```shell
dig @127.0.0.1 -p 8600 "$HOSTNAME.node.consul"
```

```shell
dig @127.0.0.1 -p 8600 "$HOSTNAME.node.dc2.consul"
```


## Services

Can add via HTTP API or via config files:

```shell
sudo mkdir /etc/consul.d
```

```shell
sudo chown -R hari /etc/consul.d
```

```shell
cat > /etc/consul.d/web.json <<EOF
{ "service": { "name": "web", "tags": ["rails"], "port": 80 } }
EOF
```

Tell agent to use config dir:

```shell
consul agent -dev -bind 192.168.99.1 -config-dir /etc/consul.d/
```

Send `SIGHUP` to agent for it to pick up changes to this dir:

```markdown
killall HUP consul
```

### HTTP API

HTTP API service query:

```shell
curl localhost:8500/v1/catalog/service/web
```

```none
[{"Node":"agrippa.local","Address":"192.168.99.1","ServiceID":"web","ServiceName":"web","ServiceTags":["rails"],"ServiceAddress":"","ServicePort":80,"ServiceEnableTagOverride":false,"CreateIndex":5,"ModifyIndex":5}]
```

### DNS API

DNS API service query - `NAME.service.consul` or `TAG.NAME.service.consul`:

```shell
dig @127.0.0.1 -p 8600 web.service.consul      shows node
```

```shell
dig @127.0.0.1 -p 8600 web.service.consul SRV  shows port too
```

```shell
dig @127.0.0.1 -p 8600 rails.web.service.consul SRV  shows only nodes with the tag "rails"
```

DNS only serves queries for `.consul` by default (not recursive resolver)

DNS TTL 0 (default) for freshness

```none
dns_config.node_ttl
service_ttl.<service>  HTTP API prepared queries can specify TTL per query! Or use default for service
service_ttl.*
```

Only single leader services reads (default):

- to allow read from any server for horizontally scaling reads (less fresh)

```none
dns_config.allow_stale      default: off
dns_config.max_stale        default: 5, requires allow_stale
```

DNS clients + forwarders often cache negative responses (M$ for 15 mins!), must disable that behaviour in clients / forwarders

## Multi-DC

Show only servers participating in wan gossip protocol:

```shell
consul member -wan
```

Client always use dc-local servers so do not participate in wan gossip protocol.

```shell
consul join -wan <svr1> <svr2>
```

```none
/v1/catalog/nodes?dc=dc2
/catalog/datacenters
```

## Cluster test

```shell
mkdir -p -v ~/vagrant/consul &&
cd ~/vagrant/consul &&
wget https://raw.githubusercontent.com/hashicorp/consul/master/demo/vagrant-cluster/Vagrantfile &&
vagrant up
```

```shell
vagrant ssh n1
```

```shell
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -node=agent-one -bind=172.20.20.10 -config-dir /etc/consul.d
```

In another terminal:

```shell
cd ~/vagrant/consul # for Vagrantfile to resolve n2
vagrant ssh n2
```

```shell
consul agent -data-dir /tmp/consul -node=agent-two -bind=172.20.20.11 -config-dir /etc/consul.d
```

at this point we have 2 single node clusters.

In another terminal:

```shell
cd ~/vagrant/consul # for Vagrantfile to resolve n1
vagrant ssh n1
```

Only needs to know one existing member (seed), learns rest via gossip protocol.

Can use CLI join startup option with seed nodes or HTTP API `start_join`.

```shell
consul join 172.20.20.11
```

```none
Successfully joined cluster by contacting 1 nodes.
```

Tie all 3 nodes together in cluster:

```shell
consul join <node1> <node2> <node3>
```

prefer:

```shell
consul agent -server -bootstrap-expect 3 -data-dir /tmp/consul
```

```shell
consul members
```

```none
Node       Address            Status  Type    Build  Protocol  DC
agent-one  172.20.20.10:8301  alive   server  0.6.1  2         dc1
agent-two  172.20.20.11:8301  alive   client  0.6.1  2         dc1
```

```shell
dig @127.0.0.1 -p 8600 agent-two.node.consul
```

## Health Checks

Ccripts run as user running Consul - relies on zero exit code.

Host check:

```shell
cat > /etc/consul.d/ping.json <<EOF
{ "check": { "name": "ping", "script": "ping -c1 google.com >/dev/null", "interval": "30s" } }
EOF
```

Service check (will fail as we haven't actually built a real service):

```shell
cat > /etc/consul.d/web.json <<EOF
{ "service": { "name": "web", "tags": ["rails"], "port": 80, "check": { "script": "curl localhost:80 >/dev/null 2>&1", "interval": "10s" } } }
EOF
```

```shell
killall -HUP consul
```

HTTP API - find all failing checks:

```shell
curl localhost:8500/v1/health/state/critical
```

```json
[{"Node":"agrippa.local","CheckID":"service:web","Name":"Service 'web' check","Status":"critical","Notes":"","Output":"","ServiceID":"web","ServiceName":"web","CreateIndex":11,"ModifyIndex":11}]
```

DNS API - returns no results for failing services:

```shell
dig @127.0.0.1 -p 8600 web.service.consul
```

HTTP API - returns identical information to earlier even when service is marked as failed?:

```shell
curl localhost:8500/v1/catalog/service/web
```

```json
[{"Node":"agrippa.local","Address":"192.168.99.1","ServiceID":"web","ServiceName":"web","ServiceTags":["rails"],"ServiceAddress":"","ServicePort":80,"ServiceEnableTagOverride":false,"CreateIndex":5,"ModifyIndex":11}]
```

## Key Value Store

```none
/v1/kv/path/to/key
```

Gets a 404 because there are no keys yet:

```shell
curl -v http://localhost:8500/v1/kv/?recurse
```

Queries below return "true" or "false" without quotes or newline:

Put some test keys

```shell
curl -X PUT -d '12' http://localhost:8500/v1/kv/web/key1
```

```shell
curl -X PUT -d 'test' http://localhost:8500/v1/kv/web/key2?flags=42 all keys have optional 64-bit integer
```

```shell
curl -X PUT -d 'test'  http://localhost:8500/v1/kv/web/sub/key3
```

Now same recurse query will return a list of json objects on one line, with Value field base64 encoded to allow
non-UTF-8 chars:

```shell
curl -v http://localhost:8500/v1/kv/?recurse
```

```shell
curl http://localhost:8500/v1/kv/web/key1
```

```json
[{"LockIndex":0,"Key":"web/key1","Flags":0,"Value":"dGVzdA==","CreateIndex":10,"ModifyIndex":10}]
```

Delete everything under `/web/sub`:

```shell
curl -X DELETE http://localhost:8500/v1/kv/web/sub?recurse
```

```shell
curl http://localhost:8500/v1/kv/web?recurse
```

Check-and-Set behaviour to guarantee atomic updates - supply the last ModifyIndex eg. 97 as seen by GET on the key:

```shell
curl -X PUT -d 'newval' http://localhost:8500/v1/kv/web/key1?cas=97
```

Wait behaviour - return the key only when it's ModifyIndex reaches 101 - additionally put a 5 sec timeout on that
and returned whatever it is after 5 secs:

```shell
curl "http://localhost:8500/v1/kv/web/key2?index=101&wait=5s"
```

## UI

Nice for exploring node / service health and creating/getting keys.

Start the agent with the `-ui` argument to enable `:8500/ui` endpoint:

```shell
consul agent -ui
```

###### Ported from private Knowledge Base page 2015+
