# TCollector

[:octocat: OpenTSDB/tcollector](https://github.com/OpenTSDB/tcollector)

Client-side metrics collector for OpenTSDB.

See [OpenTSDB](opentsdb.md) doc first.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Collectors](#collectors)
  - [Readily Available Collectors](#readily-available-collectors)
- [Setup](#setup)
- [Test run TCollector plugins](#test-run-tcollector-plugins)

<!-- INDEX_END -->

## Key Points

- forwards metrics to OpenTSDB's TSD daemon
- handles buffer + retry so shell scripts / plugins don't have to handle this logic
- de-duplicates repeated values
  - remembers last value, only sends changes or repeats value once every 10 mins otherwise
- runs any script in `collectors/<digit>/` directories, ignores other dirs
  - `0` - dir of long running programs
  - `15` - dir of scripts it executes every 15 secs
  - `30` - dir of scripts to execute every 30 secs
  - `60`
  - `75`
  - `90` - must be a multiple of 15 as TCollector checks every 15 secs
- automatically kills collector and restarts it if no output in 600 secs
- collectors are script plugins that collect metrics from the OS or applications and output them to stdout
  - TCollector reads them, buffers and sends them to OpenTSDB TSD daemon

## Collectors

Collector scripts simply output in this format to stdout:

```text
<metric> <ts> <value> tag1=value1 tag2=value2 ... host=<hostname/fqdn>
```

TCollector automatically adds the `host=` tag for you.

Stderr goes to `/var/log/tcollector.log`.

### Readily Available Collectors

Comes with Python scripts in `0/` for:

- `df`, `ifstat`, `iostat`, `netstat`, `nfsstat`, `procstats`, `SMART` stats
- Couchbase
- Elasticsearch
- Hadoop DN JMX
- HAProxy
- HBase RS JMX
- MongoDB
- MySQL
- PostgreSQL
- Redis
- Riak
- Varnish
- ZooKeeper

## Setup

```shell
git clone https://github.com/OpenTSDB/tcollector
```

```shell
./tcollector.py -h
```

Wrapper script:

```shell
./tcollector start <tcollector_args>
```

Options:

```text
-c --collector-dir
-d --dry-run  # just print don't send metrics
-H --host <tsd1>
-L --hosts-list <tsd1>:4242,<tsd2>:4242,...
-t <tag>  # defaults to <fdqn>
--http  # send data via HTTP interface
--http-username
--http-password
```

Set log and pid locations to avoid permission denied exceptions to `/var/log/tcollector.log`
and `/var/run/tcollector.pid`:

```shell
./tcollector.py --dry-run -c collectors --logfile /dev/stdout  --pidfile /tmp/tcollector.pid
```

Lots of exceptions for modules not installed, `/proc` and `netstat -lntp` not available on Mac etc...
G1GC `/var/log/gc` not available etc.

XXX: Docker bind mount `/proc` and `/sys` for container to report host metrics

## Test run TCollector plugins

Python will fix a module's path to the first place it finds it so you cannot put some stuff locally
and then expect to find others in `collectors/lib/utils.py`

```shell
PYTHONPATH=/usr/local/tcollector /usr/local/tcollector/collectors/0/netstat.py
```
