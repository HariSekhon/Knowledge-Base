# Couchbase

See also [Memcached](memcached.md) doc.

- Memcached => Membase => Couchbase (2.0 Jan 2012)
- CouchDB's views (like MongoDB queries) were added to Couchbase 2.0+
- Couchbase buckets - 20MB, persistence, replication, rebalance, in-built client hashing
- Memcached buckets - 1MB
- Admin UI
- CLI
- REST API (used by UI + CLI)

Couchbase needs more RAM than Docker Machine's Boot2Docker VM has :-/ - use on Mac natively instead:

http://packages.couchbase.com/releases/4.1.0/couchbase-server-enterprise_4.1.0-macos_x86_64.zip

- Enterprise - SSL Web UI + Rest API
- PWs for admin, per bucket, per XDCR connection
- LDAP vis SASL
- SSL for SDKs (Java, C# / .Net, Node.JS, PHP, C# - no Python SSL?)
- client chooses whether to encrypt
- auditlog - stored as JSON
- 25 event types only created by CB
- modifying log is itself logged
- Encryption-at-Rest:
  - Vormetric integration provides this
  - fully transparent to Couchbase
  - encrypts Data, Indexes, tools, password files, config, logs
- No topology, hierarchy or master-slave, entirely peer-2-peer so no rack awareness... rack safety??
- Replication configured per bucket, as is XDCR
- Replication is only enabled when the (num nodes) in cluster >= (active+replica) count
- Cannot change replication factor after bucket creation
- Ketema - consistent hashing for Memcached

### Pricing

Last known invoice cost in 2013 at a client:

Enterprise Premium 2 years x 26 nodes = $265,000

### Ports

| Port Number   | Description                                                                                                                     |
|---------------|---------------------------------------------------------------------------------------------------------------------------------|
| 8091          | Web UI                                                                                                                          |
| 8092          | Couchbase API (used to access views)                                                                                            |
| 11209         | Internal Bucket Port                                                                                                            |
| 11210         | Memcapable 2.0 API client interface (used by Moxi and smart clients to direct access node's data using client side cluster map) |
| 11211         | Memcached 1.0 API client interface (memcached protocol embedded proxy)                                                          |
| 4369          | Erlang Port Mapper (epmd)                                                                                                       |
| 21100 - 21199 | Node data exchange                                                                                                              |

For inter-node communication you need to allow access to ports 8091 and 11210

REST API is the basis for all the command line tools as well as the web UI

XDCR - Cross DataCenter Replication (bi-directional!) read/write at both DCs. XDCR ONLY REPLICATES ON CHANGE, no existing data is transferred :(

Moxi = Proxy, can be client-side or server-side. Server-side embedded proxy (port 11211) is not recommended for production since it introduces an extra network hop. If using Ketama you can end up with Memcached hash to proxy, then another hash hop to the right server...

- can create one read-only user account which can access the WebUI + REST API

- bucket === keyspace
- working set cache management
- read + write consistent

1. key lookup
2. MapReduce Views (2.0+) - distributed secondary indexes, accessible via REST API
3. N1QL queries (4.0+) - SQL superset for inexing + querying JSON docs

- 256 byte key
- 20MB val blob:
  - null
  - JSON (usually)
  - serialized object
  - XML
  - text
- all kv are docs:
  - JSON
- key unique within bucket

- CAS - compare & set
  - every doc create/change gets a new CAS value (like ModifyIndex in Consul)
- metadata:
  - TTL (optional)
  - SDK specific flags
  - concurrency??

CAS - optimistic locking
GetL - pessimistic locing

prefer atomic ops, then CAS, then GetL as it can cause other threads to block

Per Bucket:

- Cache Management
- Replication
- Indexing
- XDCR

Buckets:

- database
  - < 5
  - never more than 10
  - each bucket has overhead CPU + Disk + allocated RAM
- 1024 vBuckets spread across nodes
  - CRC32 hash-mod of keys
- Cluster Map of vBucket locations maintained in each client by SDK, kept up to date by Couchbase server
- Caching & Persistence
  - each bucket shares thread pool to handle persistence
- Replication:
  - each bucket shares thread pool to handle replication
  - up to 3 replicas for doc - RAM replication - machine failure protection only
  - replicas never on same node
  - rack aware replica placement
- DCP (Database Change Protocol):
  - RAM to RAM streaming
  - ordered mutations
  - consistent data snapshots
  - no-loss recovery if interrupted
  - used for:
    - local persistence
    - inter node replication
    - XDCR
- Rebalancing:
  - at bucket level upon node add/remove/fail
  - replicas promoted to active get a new replica


- N1QL (4.0+) - ODBC / JDBC
  - can access MapReduce Views

MapReduce Views (2.0+) - sum, count, stats built-in
- custom
- REST API callable
- http://host:8092/$bucket/_design/$doc_key/_view/$function?limit=10

MR Views - design docs with Javascript functions processed by V8 JS Engine (Node.js)
- emits new key + value

```
function(doc, ??){
  if(doc.sales > 10000){
    emit(doc.city, [doc.name, doc.sales]);
  }
}
```

Nodes contain:

- Cluster Manager:
  - UI
  - Rest API
  - Configuration
  - Process Monitoring
  - Stats collection
  - Coordinates Cluster Re-balancing, does no data mgmt, written in Erlang + OTP (telco carrier grade reliability)

- Node Manager, 3 services written in C++ / Go (fast + efficient memory footprint):
  - Data service:
    - MapReduce views
    - Distributed Indexes
  - Index service:
    - Global Secondary Indexes
  - Query service:
    - N1QL coordinator + execution engine
    - can access newer Global + older MR distributed indexes

Independently scalable - allows varying hardware profiles
- different architectures for application workload tuning eg:
- 1. Stripe across all nodes
- 2. Isolate to specific nodes
- 3. Scale independently choosing best hardware for each workload

Data service:
- tcp binary (fast)
- Managed Cache
- Persistence Queue - shared multi-threaded pool
- Replication Queue - another shared multi-threaded pool
- Storage (disk)
- Application Server (for SDK)

- NRU - Not Recently Used algo
  - common docs stay in RAM
  - each read lowers score
  - periodic item pager raises score
  - on mem high water mark it ejects high score docs until reaches low water mark
- Ejection - value only (default)
  - full - key + value + metadata
- Writes - async
  - ack configurable per write
  - ack default on RAM (!!)
  - or ack on write
  - or ack on replicated (+ 1, 2 or 3 replicas)
- WAL - append only
  - tombstones
  - periodic compaction (low impact)
- Replication - RAM-to-RAM

Node add (UI/Rest) triggers:
- vBuckets rebalanced by incremental transfer of both active + replica docs
- Cluster Map updated continuously during migration, zero downtime

Node failure - timeout or failure
- replicas promoted (but not re-replicated!! no new replica created to take it's place by default)
- Cluster Map in clients updated
- Rebalance optional (but required to trigger replicas to be re-replicated so not really optional)
- XXX: always run a rebalance after node failure to trigger new replacement replica creation

App Server - SDK client is single logical conn to Couchbase
- multiple pooled conn maintained by Couchbase library
- cluster topology abstracted by Cluster Map

XDCR:
- RAM-to-RAM inter-cluster replication
- configurable per bucket
- single or bi-directional
- mutations pushed after local persistence?
- each cluster can have different topology
- SSL optional - 32 encrypted SSL streams (default) among all vBuckets, both intra + inter cluster
- when several mutations same doc, only latest version is sent
- resilient - regular checkpoints, recovery starts from last checkpoint
- no-loss auto-recovery if any node fails at either end

Mobule:
- Couchbase Lite:
  - 100% open source
  - mobile lightweight fully functional embedded NoSQL engine
  - online/offline equally fast due to running off local copy
  - can listen for DB changes
  - can replicate peer-to-peer
- Couchbase Sync Gateway:
  - authentication + access control
  - replication
  - data routing

Connectors:
- Hadoop Sqoop Connector
  - streams keys to HDFS or Hive
  - supports Cloudera + Hortonworks (CDH versions referenced though)
- Spark?
- Elasticsearch plugin
- Solr connector
- ODBC/JDBC by Simba
- Talend connector
- SpringData for Couchbase - Java POJO model for CB buckets

## Monitoring

See also [Memcached Monitoring](memcached.md#monitoring) doc.

- mem_used < RAM quota - else [OOM killer](performance.md#oom-killer---out-of-memory-killer)
- mem_used < ep_mem_high_wat - otherwise data is being ejected to disk
- ep_queue_size - disk queue size
- get_hits >= 90% - cache hits
- get_misses < low - data is not being fetched from RAM

To get all the above on Couchbase:

```shell
cbstats localhost:11210 all | egrep "todo|ep_queue_size|_eject|mem|max_data|hits|misses"
```

- ram ejections
- vbucket errors
- oom errors per sec should be 0
- temp oom errors per sec
- connections count

- disk queue length
- warmup (per node per bucket operation if omitting the bucket name it'll only check default, must iterate on buckets for each node)
  - ep_warmup_thread = complete OK, running = WARNING
  - ep_warmup_state = done OK, else WARNING

TODO: Nagios document plugin

TODO: Nagios REST API 40 metrics

## Backup

Backup per-node configuration:

```
/opt/couchbase/var/lib/couchbase/config/config.dat
```

Data Stored here:

```
/opt/couchbase/var/lib/couchbase/data
```

## XDCR Setup

- Cluster 2 - create bucket to replicate to
- Cluster 1
  - UI -> XDCR -> create cluster -> host:ip of Cluster 2
  - create Replication -> cluster drop-down, bucket1 drop-down, enter bucket2 name

## CLI

On Mac:

```
/Applications/Couchbase Server.app/Contents/Resources/couchbase-core/bin
```

On Linux:

```
/opt/couchbase/bin
/opt/couchbase/bin/install
/opt/couchbase/bin/tools
```

N1QL shell:

```shell
cbq
```

```shell
couchbase-cli server-list -c localhost
```

```shell
couchbase-cli bucket-list -c localhost
```

parse + analyze core dump:

```shell
cbanalyze-core
```

Copy data from entire cluster bucket or from single node bucket

```shell
cbbackup
```

Detailed stats for a given node:

```shell
cbcollect_info
```

Load JSON data from a dir or single .zip file:

```shell
cbdocloader -u Administrator -p testest -b testbucket -n host:port -s RAM_MB_quota # if bucket does not exist
```

Reset Administrator or read-only user password:

```shell
cbreset_password
```

Restore from file to cluster or bucket:

```shell
cbrestore
```

Get node / cluster stats around perf / storage:

```shell
cbstats
```

```shell
cbstats localhost:11210 [-b bucket] raw workload
```

Generate random data + perf read / writes:

```shell
cbworkloadgen -u Administrator -p testtest
```

Only changes one bucket on one node at a time:

```shell
cbepctl
```

### N1QL workshop 20/1/2016 @ Couchbase office London near Old Street

Couchbase 4.0+

http://developer.couchbase.com/documentation/server/4.0/n1ql/n1ql-language-reference/index.html

N1QL command interface add dir to `$PATH`:

```shell
export PATH="$PATH:/Applications/Couchbase Server.app/Contents/Resources/couchbase-core/bin"
```

```shell
cbq [-engine=http://123.45.67.89:8093]
```

```sql
SELECT * FROM `travel-sample` WHERE type='airport';
```

Aggregate Functions (not in reserved words list, check several sub-lists)

```sql
SELECT COUNT(*) FROM `travel-sample` WHERE TYPE='airport' AND country='France';
```

```sql
SELECT ROUND(AVG(geo.alt)) FROM `travel-sample` WHERE TYPE='airport' AND country='France';
```

The order changes each time due to distributed independent indices:

```sql
SELECT DISTINCT(airline) FROM `travel-sample` WHERE equipment LIKE '%380%';
```

## N1QL

Selects all docs from `FROM` clause before projecting `SELECT`

| Characters | Description           |
|------------|-----------------------|
| \|\|       | concatentates strings |
| _          | single char wildcard  |
| %          | variable wildcard     |

```
    "results": [
          {...},
          {...}
    ],
    "status": "success",
    "metrics": {
        "elapsedTime": "82.938144ms",
        "executionTime": "82.882547ms",
        "resultCount": 8,
        "resultSize": 3449
    }
```

if you don't use `AS fullname` then it'll set it as `$1`:
```sql
SELECT u.firstname || " " || u.lastname AS fullName FROM myBucket AS u LIMIT 1;
```

Same as get() from API - attribs are case sensitive:

```sql
SELECT * FROM myBucket[.attrib][.attrib] USE KEYS "myKey"
```
```
["myKey", "myKey2"]
```

```sql
WHERE <attrib> IS MISSING
IS NOT MISSING
IS NULL
```

Find in list of objects/hashes
<expression>
```sql
WHERE ANY x IN <attrib> SATISFIES x.rating > 4 END
```

```sql
SELECT a JOIN b ON KEYS ARRAY "track:" || trackId FOR trackId IN b.tracks END;
```

```sql
SELECT META() AS metadata FROM ...
```

```
cas: <int>
flags: 0 # <- SDK specific flags
id: <key>
type: json # <- SDK specific type
```

See Indexes via Admin UI or N1QL query

```sql
select * from system:indexes where keyspace_id=myBucket
"index_key": <key_stmt>
"using": "gsi"
```

attrib must match WHERE clause including parent path in query component eg. 'user.email' vs 'email' for index to be used:

```sql
CREATE INDEX <name> AS myBucket(attrib) [ USING GSI|VIEW ] # GSI = default, VIEW = old MR Views
[ WITH  ... ]
```
Index creation is blocking by default - can make async using `WITH` defer build but only works with one at a time

```sql
WITH {"defer_build": true}
```

Indexes are auto-maintained by Couchbase after creation

Filtered Index - only includes docs where attrib2=blah
- must specify `WHERE attrib2=blah` clause in queries to use this index (WHERE ordering insensitive)

```sql
CREATE INDEX <name> AS myBucket(attrib) WHERE attrib2=blah;
```

```
explain select ...
"operator": "PrimaryScan"   <= using primary index (ie not using the index we created)
"index": "#primary"
```

"operator": "IndexScan"     <= using our secondary index
"index": "<index_name>"

15 errata submitted http://www.couchbase.com/issues/browse/MB-9840

### Couchbase presentation at client in 2014

with Tom Green, David (sales EMEA), Lee Rights (acc mgmt)

- 2013 400% growth, 500% in EU
- 100% open, source, Enterprise is 100% open source but binary - licensed for non-prod, use 2.5.1 Enterprise
- consolidate Cache + Persistent DB, eg 150 Redis + 150 MongoDB nodes
- Bucket === DB, replication configured per bucket
- rack awareness added recently
- partnered with ElasticSearch for Full Text Search - async streaming to ES
- XDCR async, no synch available, configured using a seed node on peer cluster
  - Apple gets around this by creating a software ack layer that writes to 2 DCs before returning ack to client
- XDCR Multi-Master consistency
  - set stick to DC
  - conflict resolution "most updated"
- not LRU cache => NRU (Not Recently Used) - bitmask of access counters, reset daily, persists bitmask to disk for restarts
- fine-grained locking (per hash not per doc - one hash can match a few docs)
- TTLs on docs
- SDK - Java, C#, Python, Ruby
- Client library maintains Cluster Map from Seed list (nodes to bootstrap from)
- vBuckets hash-mod to 0-1023 vBuckets - cannot have more than 1024 servers
- Amadeus 30 nodes 1M reads + 1M writes per sec
- Query round-robin to any node for scatter gather
- Scatter Gather for Secondary Index or Aggregation queries - N1QL -> single node -> rest of cluster
- Javascript creates indexes (secondary) (N1QL to take over that?)
- Analytics - lightweight analytics on JSON documents
- Indexes - async updated - less strong consistency, option to update sync
  - 2.x disk -> index, 3.x RAM -> index update
- 1 node primary for writes
- configurable timeout for node failover 30 secs default/recommended (trade-off to avoid cascading failures)
- client timeout configurable default 2.5 secs
  - XXX: socket timeouts?
- slave reads available in failover
- can trigger failover via monitoring instead, CLI or REST API
- Cluster Rebalance manually triggered
- Tunable Consistency - write to RAM, multiple nodes RAM, disk - per transaction
- CLI tool to bulk load data from file
- Code example available for pushing via API
- Connector for Hadoop - async write to Hadoop

### REST

```
/pools/default/buckets/bucket_name
```

rename node before it's part of the cluster (eg. for AWS):

```shell
curl -v -X POST -u "$COUCHBASE_USER:$COUCHBASE_PASSWORD" "http://COUCHBASE_SERVER:8091/node/controller/rename" -d "hostname=newname.domain.com"
```

### SDKs

- single point of control to cluster
- pooled client conns
- wire encryption (SSL)
- JSON serialization / deserialization (and use 3rd party instead eg. Jackson / Gson)
- CRUD via API or N1QL
- doc indexing + querying via N1QL or MR Views
- sync or async API
- supports Reactive model


- insert - fails is exists
- replace - fails if not exists
- remove - fails if not exists
- upsert - no existence or CAS check
- append
- prepend
- get
- getReplica - retrieves from replica rather than primary
- getAndLock
- getAndTouch
- unlock
- touch - updates TTL
- counter - ++/-- vals

### Python API

Official API

Requires C library otherwise gets compile error:

http://developer.couchbase.com/documentation/server/4.0/sdks/c-2.4/download-install.html#c-download-install

```shell
wget http://packages.couchbase.com/clients/c/couchbase-csdk-setup
```

but this only supports RHEL and Ubuntu/Debian systems

```shell
sudo perl couchbase-csdk-setup
```

for Mac:

```shell
brew update
```

```shell
brew install libcouchbase
```

now

```shell
pip install couchbase
```

Wrapper around with some validation functions (inspired by MongoKit)

```shell
pip install couchbasekit
```

### Key Design

convention

```
<type>::<id>
```

```
customer::12345
```

### Java SDK

JsonObject is a Map
- JsonDocument = JsonObject + metadata  (std used across all SDKs)
- use Jackson ObjectMapper or Gson (by Google) for converting Json <=> POJO
- com.couchbase.client.java.transcoder.stringToJsonObject(jsonString).
  .jsonObjectToString(jsonObject)
  or JsonObject.toString()

optional first arg for settings (eg. timeout), second arg String/List of nodes

```java
Cluster cluster = CouchbaseCluster.create("127.0.0.1");

Bucket bucket = cluster.openBucket("test", "myPassword");

JsonObject user = JsonObject.empty()
.put("first", "Hari")
.put("last", "Sekhon");
```

Store doc:

```java
JsonDocument stored = bucket.upsert(JsonDocument.create("myKey", user));
```

Retrieve doc - returns JsonDocument or null, throws CouchbaseException, TimeoutException etc:

```java
JsonDocument doc = bucket.get("myKeyId", [timeout]);
doc.getString("first")
```

More useful stuff:

```java
JsonDocument.create(id, [expiry], jsonObject, [CAS]); // # static factory method
extract jsonObject
jsonDocument.content()
```

Bucket

```java
insert(doc, [persistent_ram_or_disk], [replicas (1-3)], [TimeUnit timeout]);
getAndLock()     // # get, then change CAS
getAndTouch()    // # get, then update TTL
getFromReplica() // # get replica, stale?

.upsert() // very fast - no check for exitence like insert() / replace() / remove(). No CAS check, does not through exception on CAS value mismatch! Simple straight append to WAL. Use replace() / remove() if need locking
.replace() // fails if not exists, tombstones - periodically compacted, done after cache update - everything in CB is RAM first by default
.remove()  // fails if not exists
```

Create a counter or increment it if already exists, returns JsonLongDocument

```java
.counter(id, [increment_by], [initial], [timeout])
```

N1QL - supply string query or Statement object:

```java
SimpleQuery.simple("<query>", [query_options]);
ParameterizedQuery.parameterized("<query>", [values], [query_options]);
PreparedQuery.prepared(QueryPlan, [values], [query_params]);
```

Query Params for above:

```java
ScanConsistency.NOT_BOUNDED     // default
.REQUEST_PLUS    // strong consistency per request
.STATEMENT_PLUS  // strong consistency per statement
```

###### Partial port from private Knowledge Base page 2013+
