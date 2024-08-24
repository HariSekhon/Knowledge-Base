# OpenTSDB

<https://github.com/OpenTSDB/OpenTSDB>

Open Source Time Series Database by StumbleUpon.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [TSD - Time Series Daemon](#tsd---time-series-daemon)
  - [Tags - case sensitive](#tags---case-sensitive)
  - [HBase Keys](#hbase-keys)
  - [UIDs](#uids)
- [Metrics Management](#metrics-management)
  - [Find Metrics](#find-metrics)
  - [Rename Metrics](#rename-metrics)
  - [Rename existing collected metrics](#rename-existing-collected-metrics)
- [Query Language](#query-language)
  - [Timestamp Format Example](#timestamp-format-example)
  - [Curl Query Example](#curl-query-example)
  - [Fetch list of metrics](#fetch-list-of-metrics)
  - [Fetch list of tags keys](#fetch-list-of-tags-keys)
  - [Tag Filters](#tag-filters)
- [Docker](#docker)
- [OpenTSDB Setup](#opentsdb-setup)
  - [Bootstrap Tables](#bootstrap-tables)
  - [Tables](#tables)
  - [Metric Creation - Manual vs Automatic](#metric-creation---manual-vs-automatic)
  - [Start TSD daemon](#start-tsd-daemon)
  - [Create Sample Data](#create-sample-data)
  - [Cron Cache Clean Daily](#cron-cache-clean-daily)
- [TCollector - Metrics Agent](#tcollector---metrics-agent)
- [OpenTSDB Commands](#opentsdb-commands)
- [Best Practices](#best-practices)
- [Performance Tuning](#performance-tuning)
- [History Retention](#history-retention)
- [APIs](#apis)
  - [Telnet API](#telnet-api)
  - [HTTP API](#http-api)
- [Troubleshooting](#troubleshooting)
  - [Performance Problems](#performance-problems)
- [Aardvark](#aardvark)
- [Diagram - OpenTSDB on Kubernetes, over HBase on Hadoop](#diagram---opentsdb-on-kubernetes-over-hbase-on-hadoop)

<!-- INDEX_END -->

## Key Points

- Port - TCP 4242 - used for both metrics and Admin UI
- stores series of points over time for each metric
  - fine grained metrics - doesn't lose granularity over time like RRD / [InfluxDB](influxdb.md)
  - `<metric> + <timestamp> + <tags> + <value>`
- built on [HBase](hbase.md)
  - also has support for:
    - [Cassandra](cassandra.md)
    - Google BigTable
- re-writes row per hour (compactions)
- rudimentary graphing (use [Grafana](grafana.md) instead)
- single jar
- REST API - 2.0+
- Kerberoes 2.2+ via AsyncHBase client
- XXX: HTTP Auth (2.2+) - not prod yet
- float precision not suitable for exact measurements like currency, may return slight rounding errors
- 2.0+ - added Rate & Counter functions

### TSD - Time Series Daemon

- connects to HBase
- run multiple TSDs behind an [Load Balancer](load-balancing.md) like [HAProxy](haproxy.md) to scale out horizontally
- single TSD can handle thousands of writes/sec

### Tags - case sensitive

- store up to 8 tags per metric (default)
- `[\w\._/-]` - alpanumeric, dash, dot, underscore, forward slash permitted
- more flexible querying by tag groupings (eg. per datacenter, sub-categories)

- `tagk` - tag key
- `tagv` - tag value

### HBase Keys

- tags are in sorted order eg. `dc=1,host=<fqdn>`

`<metric_UID> + <timestamp_epoch_base_hour> + <tags>`

### UIDs

- unique UID incremented + recorded for each `metric` / `tagk` / `tagv`, stored in `tsdb-uid` HBase table
- used to save bytes in HBase table row key prefixes
- `mkmetric` assigns UID or is auto-assigned by `tsd.core.auto_create_metrics = true` setting
- minimize cardinality of `metrics` / `tagk` / `tagv`
  - each will use the same UID if their string is the same
  - only 16M UIDs by default
  - must not change `tsd.storage.uid.width.metric` / `tsd.storage.uid.width.tagk` / `tsd.storage.uid.width.tagv` after install
- each new `metric` / `tagk` / `tagv` requires lookup, assign, cache
- pre-assign UIDs to as many `metric` / `tagk` / `tagv` as possible to avoid above cost
- pre-split UID table `00001` to `N` hex prefixes
- OpenTSDB restart will have lower performance until UID cache is warmed up / filled
- UID is prefix of HBase rows - 2.2+ can optionally randomize generated UIDs to spread writes of new metrics across
  regions: `tsd.core.uid.random_metrics = true`
  - will retry 10 times to find non-collision new UID - probability of collision goes up as num metrics increases, may want to switch off or increase metric byte size (requires migrating data to new table)

- do not mix `s` + `ms` timestamp precision as it takes longer to iterate dual, use one or the other
- `ms` takes twice as much storage even though epoch only goes from 10 => 13 digits (`ms` gives 3 milliseconds `.SSS`)

Appends (2.2+) - avoids queue of rows to compact each hour, costs more HBase CPU + HDFS traffic

- dups out of order will be repaired + rewritten to HBase if `repair_appends` configured but this will will slow down
  queries: `tsd.storage.repair_appends = true`

## Metrics Management

### Find Metrics

```shell
tsdb uid grep <metrics/tagk/tagv> [<regex>]
```

```shell
tsdb uid grep metrics g1.*generation
```

### Rename Metrics

- cannot rename to an already existing name
- this will merely rewrite the UIDs in metadata

```shell
tsdb uid rename metrics <old> <new>
```

### Rename existing collected metrics

Dump in input format:

```shell
tsdb scan --import ... > file.txt
```

Rename in the `file.txt`

Re-import metrics:

```shell
tsdb import file file.txt
```

Delete old metrics:

```shell
tsdb scan --delete ...
```

## Query Language

- every query requires:
  - start time
  - end time (optional: defaults to `now` on TSD system)
  - time:
    - epoch timestamp - 10 digits for secs, 13 digits for ms `ssssssssss.SSS` format
      - time is stored in epoch format
    - explicit - `YYYY/MM/dd[[-\s]HH:mm:ss]` - assumes midnight if time is not given
    - `<num><units>-ago` where units:
      - `ms`- millis
      - `s` - secs
      - `m` - minutes
      - `h` - hours
      - `d` - days
      - `w` - weeks
      - `n` - months
      - `y` - years

### Timestamp Format Example

```none
start=1h-ago now sys.cpu.user host=x
```

### Curl Query Example

```shell
curl opentsdb:4242/q?'start=1h-ago&m=sum&sys.cpu.system{host=blah}'
```

### Fetch list of metrics

Leave `q=` blank:

```shell
curl opentsdb:4242/api/suggest?type=metrics&q=&max=10000
```

### Fetch list of tags keys

```shell
curl opentsdb:4242/api/suggest?type=tagk&q=&max=10000
```

### Tag Filters

- `host=A|B` - plots line for hosts A and B
- `host=*`   - one plot line for every host
- `literal_or(hostA|hostB)`
- `wildcard(*hostA*)`
- `regex(web.*)`
- `web[0-9=.domain.com`

Show loaded filters + examples:

```shell
curl opentsdb:4242/api/config/filters
```

Click `+` tab to add metric to existing graph.

## Docker

Peter Grace provides the most used docker images:

```shell
docker run -ti --name opentsdb \
               -p 4242:4242 \
               --rm petergrace/opentsdb-docker
```

```shell
docker run -ti --name grafana \
               -p 3000:3000 \
               --link opentsdb:tsdb petergrace/grafana-docker
```

## OpenTSDB Setup

1. install rpm / deb from github

1. `/etc/opentsdb/opentsdb.conf`:

```ini
   tsd.storage.hbase.zk_quorum = ...
   tsd.core.auto_create_metrics = true
   tsd.core.enable_api = true
   tsd.core.enable_ui = true
   tsd.network.keep_alive = true
   # Salting (2.2+) - do not change after writing data!
   bucketing = hash(metric + tags) % N
   tsd.storage.salt.buckets = 20   # set to num RegionServers, trade off as requires this many scanners + collating results, set to num pre-split regions HexStringSplit
   tsd.storage.salt.width = 0      # bytes, disabled by default for backwards compatability - set to 1 byte to enable salting + use up to 256 buckets
```

3. bootstrap create HBase tables

### Bootstrap Tables

Compression options: `NONE`/`GZIP`/`LZO` - use compression it will save loads of space

Create the basic 4 HBase tables that OpenTSDB uses:

```shell
COMPRESSION=SNAPPY \
HBASE_HOME=/hbase \
/usr/share/opentsdb/tools/create_table.sh
```

### Tables

- `tsdb`      - metrics data (massive)
- `tsdb-uid`  - UID => name / name => UID mappings for each metric / tagk / tagv
- `tsdb-tree` - config + index for hierarchical naming scheme eg. sys.cpu.user => sys->cpu-> user for browsing
- `tsdb-meta` - ts index + metadata (2.0+)

### Metric Creation - Manual vs Automatic

#### Automatic

Set this is `/etc/opentsdb/opentsdb.conf`:

```ini
tsd.core.auto_create_topics = true
```

#### Manual

Register each metric manually - creates UID for each.

This explicit metric control helps avoid typos in sending metrics.

```shell
tsdb mkmetric metric1 metric2 ...
```

#### Find all metrics in HBase

```shell
hbase shell
```

In HBase shell:

```shell
scan 'tsdb-uid'
```

See rows will have one of the following:

```none
column=id:metrics
 ```

or

```none
column=id:tagk
 ```

or

```none
column=id:tagv
```

Contains both forward and reverse mappings.

### Start TSD daemon

Run multiple of these against HBase with an [Load Balancer](load-balancing.md) in front of them to scale.

```shell
tsdb tsd
```

### Create Sample Data

Create some sample data by reading from the OpenTSDB API's own TSD daemon runtime metrics
and sending them back into OpenTSDB as user data:

```shell
while true; do

    echo stats |
    nc 0 4242 |
    awk '{print "put "$0}' |
    nc 0 4242

    sleep 60
done
```

### Cron Cache Clean Daily

Put this in a crontab to run daily:

```shell
/usr/share/opentsdb/tools/clean_cache.sh
```

## TCollector - Metrics Agent

See [TCollector](tcollector.md) doc.

- tsdrain.py - telnet PUT received only, no HTTP API support
  - collects metrics if HBase is down for maintenance, then sends commands to OpenTSDB when it's back up

## OpenTSDB Commands

Import data:

```shell
tsdb import /path/to/file.gz
```

Query metrics:

```shell
tsdb query 1h-ago now sum metric1
```

```shell
tsdb fsck
```

```shell
tsdb scan
```

```shell
tsdb search
```

## Best Practices

- duplicates with the same timestamp result in read errors
  - `tsd.storage.fix_duplicates` - not really correct solution, overwrites so loses 'duplicate' data, which may not be actual duplicates
  - real solution - more tags to uniquely differentiate time series metric points properly
- tags:
  - lowercase `metrics` / `tagk` / `tagv`
  - use short hostname, not fqdn unless different domains as this costs you space and performance
  - tags must be low cardinality
    - otherwise won't be able to query metric as it'll get too expensive
  - use tags if planning to aggregate across time series
    - otherwise put tags in metric name for better efficiency (more targeted queries = scan less row data)

## Performance Tuning

[HAProxy](haproxy.md) TSDs, rest is mainly HBase performance tuning, see [HBase](hbase.md) doc.

You have to know the questions to design OpenTSDB metric row keys for performance.

Row split into CF per time range (I/O efficient).

Pre-Split HBase `tsdb` table to avoid HBase splits during which time OpenTSDB cannot write and must buffer.

Check OpenTSDB Admin UI Graphs:

- TSD `ConnectionMgr` Exceptions & RPC Exceptions
- TSD HTTP & HBase RPC latencies
- if seeing major increase in UIDs:
  - check `metrics` / `tagk` / `tagv` cardinality
    - use `opentsdb_list_metrics.sh --by-age` for all 3 types to see recent offenders
      - get this script by cloning [DevOps-Bash-tools](devops-bash-tools.md) repo
      - correlate new metrics vs tagk vs tagv to find team / app doing this

See also [HBase](hbase.md) doc for HBase performance tuning.

## History Retention

Clean out metrics older than 2 weeks

```shell
tsdb scan --delete 2000/01/01 $(date --date="2 weeks ago" '+%Y/%m/%d') sum "$metric"
```

or:

HBase TTLs (per column family):

On table `tsdb`:

```shell
cf 't'
```

`tsdb-meta`  - ts_ctr incremented per metric, off by default leaves `\x01` for all metrics
<br><br>
**XXX: DANGER: don't set TTL on `tsdb-uid`!!!**

## APIs

### Telnet API

- can only put single data point each time
- discouraged as doesn't show write failures

```none
put <metric> <tstamp> <value> <tagk1>=<tagv1>[ <tagk2>=<tagv2> ...]\n
```

### HTTP API

- single POST of multiple data points

## Troubleshooting

Performance problems at a client in Oslo, Norway:

1. regions not splitting + rebalancing
  - classic case of row key schema design hotspotting,
  - might be caused by metric + tag UID combinations having low cardinality, effectively data skew, various methods for mitigating this
  - 2GB data => filling 10 x 6TB disks on same server (HBase bug)

1. splitting regions manually, regions didn't migrate to other servers
  - figure out where to split the partitions, can write a program (Spark) to determine the key distribution

1. OpenTSDB bulk importer gets `RegionTooBusyException` from HBase:
  - memstore sizing
  - dfs replication since it chains, can block memstore
  - was not Major compaction issue
  - caused by data skew

### Performance Problems

1M data points in ~ 4 secs on 17 RegionServers with 20GB heap each.

Memstore:

```none
0.4 x HeapSize = ~5GB
```

1M data points in ~ 2.3 secs on same 17 regionservers  with byte pre-split ranges.

More likely to hit memstore error without pre-splitting.

## Aardvark

Metrics browser and visualizer by Simon Matic Langford of G-Research based on a tool he wrote at Betfair.

Can just use OpenTSDB's UI and autocomplete metric names.

## Diagram - OpenTSDB on Kubernetes, over HBase on Hadoop

![](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/opentsdb_kubernetes_hbase.svg)

<br><br>
**Partial port from private Knowledge Base page 2016**
