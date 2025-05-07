# Prometheus

<https://prometheus.io/docs>

Open source metrics monitoring and alerting framework.

Scrapes text-based metrics over HTTP from remote agents.

Stores metrics in a local Time Series DB with querying capabilities.

<https://demo.promlabs.com/>

<!-- no longer available
demo.robustperceptions.io:9090
-->

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Key Components](#key-components)
  - [Ports](#ports)
  - [Architecture Diagram](#architecture-diagram)
  - [UI](#ui)
  - [Metrics](#metrics)
    - [Types of Metrics](#types-of-metrics)
  - [Storage](#storage)
  - [Scaling - Thanos](#scaling---thanos)
- [Setup](#setup)
  - [Install Locally](#install-locally)
  - [Using Docker](#using-docker)
  - [Check Targets Scraping Status](#check-targets-scraping-status)
  - [Graph Page / Expression Browser](#graph-page--expression-browser)
- [HTTP API](#http-api)
- [PromQL](#promql)
- [Comparisons](#comparisons)
  - [Prometheus vs Graphite](#prometheus-vs-graphite)
  - [Prometheus vs InfluxDB](#prometheus-vs-influxdb)
  - [Prometheus vs OpenTSDB](#prometheus-vs-opentsdb)
- [Collections Agents](#collections-agents)
- [Exporters](#exporters)
  - [Node Exporter](#node-exporter)
  - [Blackbox Exporter](#blackbox-exporter)
  - [Consul Exporter](#consul-exporter)
  - [Graphite Exporter](#graphite-exporter)
  - [Memcached Exporter](#memcached-exporter)
  - [MySQLd Exporter](#mysqld-exporter)
  - [Statsd Exporter](#statsd-exporter)
  - [Kube State Metrics](#kube-state-metrics)
  - [Ccloud Exporter](#ccloud-exporter)
  - [Confluent Connector](#confluent-connector)
  - [ArgoCD Metrics](#argocd-metrics)
  - [JMX Exporter](#jmx-exporter)
  - [SNMP Exporter](#snmp-exporter)
  - [Kafka-lag Exporter](#kafka-lag-exporter)
  - [Airflow Exporter](#airflow-exporter)
- [Alert Manager](#alert-manager)
- [Push Gateway](#push-gateway)
- [PromLens](#promlens)
- [Resources](#resources)

<!-- INDEX_END -->

## Key Points

- metrics + alerting by SoundCloud
- written in Go
- second project in the CNCF after Kubernetes
- standalone, no dependencies, only local disk
- 1 static binary - `prometheus`
- 1 config file   - `prometheus.yml`
- pull based - HTTP `/metrics` scraping
- TSDB - time-series DB
- Queryable
- tag based metrics
- Push Gateway - port 9091 - for short lived jobs
- [Exporters](#exporters) - agents serving HTTP `/metrics` to be used as Scrape Targets by Prometheus server
  - lots of different exporters, see [Exports](#exporters) section for list
- Scrape Targets:
  - Static config or
  - Service Discovery - discover targets to scrape dynamically:
    - Generic - DNS, Consul, ZooKeeper
    - VMs - AWS EC2, Azure, GCP, Openstack
    - Cluster Managers - Kubernetes, Marathon ([Mesos](mesos.md))
- No Auth or TLS - use Nginx / HTTPd / HAProxy in front for SSL + Authentication
- very efficient - unlikely to need sharding + federation until thousands of machines
- Scale - single server can handle:
  - millions of metrics
  - hundreds of thousands of data points per sec
- Federation - pulling metrics from other Prometheus servers:
  - tree aggregates from other Prometheus
  - set Prometheus as scrape targets `metrics_path: /federate`
  - `match[]` section
- High Availability - dual ingest to 2 identical servers + [Load Balance](load-balancing.md)
- AlertManager email / pager:
  - discovery similar to target discovery
  - groups clients so mass outage appears as 1 alert not hundreds / thousands
  - inhibitions - suppress similar alerts
- PromQL query language:
  - can make query predictions based on current rate, such as:
    - how full will disks be in 4 hours
- not suitable for billing as not detailed / complete enough
- backfill support on roadmap ([OpenTSDB](opentsdb.md) already has this)
- Recording Rules:
  - like InfluxDB continuous queries
  - compute new time series at regular intervals
  - pre-materialise expensive queries for faster dashboards
- Alerting Rules - sends alerts
  - similar config to Recording Rules
  - based on expression results eg. `>= 1`

Key Summary:

- Multi-dimensional data model - stores metrics with labels (key-value pairs) for flexible querying
- PromQL (Prometheus Query Language) - powerful language used to query, aggregate, and display metrics
- Time-series storage - stores metrics as time-stamped values for historical analysis
- Visualization - integrates with tools like Grafana to create dashboards and visualize metrics
- Alerting - configurable alerts based on metric thresholds or conditions
- Service discovery - automatically discovers services and targets based on configurations

### Key Components

- **Prometheus Server**
  - Scrapes and stores time-series data from configured targets (like services, applications, and systems)
  - it also hosts a basic web [UI](#ui) for querying
- **[Exporters](#exporters)**
  - agents that gather metrics and present them as semi-structured text over HTTP on an non-standard port
- **Client Libraries**
  - instrument your own apps to expose `/metrics` in the Prometheus text format for Prometheus server to scrape
- **[Alertmanager](#alertmanager)**
  - handles alerts generated by Prometheus based on predefined conditions
  - routes them to appropriate channels (email, Slack, etc.)
- **Pushgateway**
  - metrics sink long-running server for short-lived jobs to push metrics to for Prometheus server to
    then scrape (since Prometheus server cannot scrape ephemeral short-lived jobs that come and go)

### Ports

| Port | Description       |
|------|-------------------|
| 9090 | Prometheus        |
| 9091 | Push Gateway      |
| 9100 | Node Exporter     |
| 9103 | Collectd exporter |
| 9273 | Telegraf exporter |

### Architecture Diagram

![Prometheus Architecture](https://prometheus.io/assets/architecture.png)

### UI

Prometheus has native Web UI on port 9090 with nice metric names autocomplete.

But [Grafana](grafana.md) is generally considered the gold standard of metric UI
and integrates with most major open source metrics and time series databases like [InfluxDB](influxdb.md)
and [OpenTSDB](opentsdb.md)

[PromLens](#promlens) is a web-based query builder for PromQL by PromLabs.

### Metrics

<https://demo.promlabs.com/metrics>

Scrapes metrics from HTTP `/metrics` endpoints called 'targets'.

Stored as:

- Timestamp - 64-bit int in ms
- Value - 64-bit float (in future will be histogram)

#### Types of Metrics

- **Gauge**: current measurement, can go up or down
- **Counter**: cumulative count over time
  - usually need to wrap it in queries with a function like `rate()` / `irate()` / `increase()`
    to be meaningful eg. `rate(my_counter[5m])`
- **Summaries**: percentiles / quantiles
  - do not aggregate across summaries - not statistically valid
- **Histogram**: bucketed stats, cumulative

For a gauge or counter that is process start time:

```shell
time() - process_start_time_seconds
```

### Storage

No long term storage, but can forward to remote storage.

Remote Storage Adapters for:

- Graphite
- [InfluxDB](influxdb.md) - write + read back
- [OpenTSDB](opentsdb.md) - write only (still use this for history graphs)
  - forwarder listens on 9201
- Cortex - scalable long term storage for Prometheus

<!-- TODO: create cortex.md page and link it above -->

Configure `remote_write` to send to remote storage.

- Read back supported on some adapters eg. InfluxDB
- But no PromQL push down - all data must be read back and computed on Prometheus
- Inefficient / Poor Performance / Non-Scalable

### Scaling - Thanos

[Thanos](thanos.md) - federates multiple Prometheus for scaling

## Setup

### Install Locally

Download and install Prometheus binary and any [Exporters](#exporters) you want to run.

You can download and extract the Prometheus tarball manually from [Downloads](https://prometheus.io/download/) page
or just run the scripts from [DevOps-Bash-tools](devops-bash-tools.md) repo
to install the latest GitHub release to your `$PATH` (`/usr/local/bin` or `$HOME/bin`):

```shell
install_prometheus.sh
```

Download starter config from [HariSekhon/Templates](https://github.com/HariSekhon/Templates) repo:

```shell
wget https://raw.githubusercontent.com/HariSekhon/Templates/refs/heads/master/prometheus.yml
```

Run prometheus:

```shell
prometheus
```

Creates `$PWD/data/` directory full of data.

Defaults worth noting:

```shell
--config.file='prometheus.yml'
--storage.tsdb.path='data/'
--storage.tsdb.retention='15d'
```

### Using Docker

Manually run:

```shell
docker run -ti -p 9090:9090 prom/prometheus
```

Using [Docker-Compose](docker-compose.md) tooling:

[HariSekhon/DevOps-Bash-tools - docker-compose/prometheus.yml](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/docker-compose/prometheus.yml)

```shell
docker-compose -f prometheus.yml up
```

Fully scripted using above `docker-compose/prometheus.yml` in [DevOps-Bash-tools](devops-bash-tools.md) repo:

[HariSekhon/DevOps-Bash-tools - kubernetes/prometheus.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/kubernetes/prometheus.sh)

```shell
prometheus.sh
```

### Check Targets Scraping Status

List the targets and check they have `UP` in the State column that they are being correctly scraped.

<http://localhost:9090/targets?search=>

### Graph Page / Expression Browser

<http://localhost:9090/graph>

Enter a metric name to query:

```promql
prometheus_tsdb_head_samples_appended_total
```

Switch from `Table` to `Graph` view tab.

Since this metric only goes up, calculate its rate of ingestion instead by changing the query to this:

```promql
rate(prometheus_tsdb_head_samples_appended_total[1m])
```

Graph the 90th percentile of request durations for the `demo` scrape target in last 5 mins split by URL /paths:

```promql
histogram_quantile(0.9, sum by(le, path) (rate(demo_api_request_duration_seconds_bucket[5m])) )
```

## HTTP API

```text
/api/v1/query?query="..."
```

## PromQL

<https://promlabs.com/promql-cheat-sheet/>

```promql
mymetric{tag1="value1", tag2!="value2", tag3=~match3, tag4!~match4}[interval]
```

```promql
http_requests_total{kubernetes_namespace="dev", _weave_service="podinfo"}))
```

```promql
sum(http_requests_total) by (kubernetes_namespace, _weave_service)
```

Interval must be at least as big as collection period otherwise will get no results for say 10s if collection interval
is 1m (default, set to 30s for prod).

```promql
rate(http_requests_total[1m])
```

Find per second:

```promql
sum(rate(http_requests_total{_weave_service="podinfo"}[1m])) / 60
```

Ratio of unsuccessful requests - put this in to a Prometheus alert > 50

```promql
sum(rate(http_requests_total{_weave_service="podinfo",status!="200"}[1m])) / sum(rate(http_requests_total{_weave_service="podinfo"}[1m]))
```

```promql
sum(rate(http_requests_total{kubernetes_namespace="dev", _weave_service="podinfo"}[1m]))
```

Alerts

```promql
ALERT errorRate
IF sum(rate(http_requests_total{_weave_service="podinfo",status!="200"}[1m])) / sum(rate(http_requests_total{_weave_service="podinfo"}[1m])) > 0.5
FOR 1m
LABELS      { severity="critical" }
ANNOTATIONS {
  summary = "error rate > 50%",
  impact = "bad",
  detail = "blah"
}
```

## Comparisons

### Prometheus vs Graphite

| Prometheus                                      | Graphite                                                               |
|-------------------------------------------------|------------------------------------------------------------------------|
| proactive (scraping, alerting, rule processing) | passive Time Series db                                                 |
| irregular timeseries                            | fixed interval                                                         |
| label name{key1=val1,key2=val2}                 | name.key.key2                                                          |
| better for filtering via labels                 | has clustering                                                         |
| arbitrary precision                             | more complicated setup                                                 |
| Whisper-like RRD overwrites old data            | Uses [Whisper](https://graphite.readthedocs.io/en/latest/whisper.html) |

### Prometheus vs InfluxDB

| Prometheus                                                 | InfluxDB                                           |
|------------------------------------------------------------|----------------------------------------------------|
| active, scrape, alert                                      | passive Time Series db                             |
| metadata for ts stored once                                | stored for every event => 11x storage              |
| indexes all columns                                        | only indexes row timestamp (0.9 targeted for cols) |
| better for cumulative (downsampling feature)               | better for storing individual events               |
| single server (must shard manually or [Thanos](thanos.md)) | clustering (proprietary)                           |
| float only                                                 | int, float, bool, string                           |
| ms only                                                    | s, ms, microsecs, nanosecs                         |
| mem + 5 min flushes = data loss                            | durable (WAL)                                      |

### Prometheus vs OpenTSDB

| Prometheus                              | OpenTSDB                                                                       |
|-----------------------------------------|--------------------------------------------------------------------------------|
| active, scrape, alert                   | passive Time Series db                                                         |
| full query language                     | lacks full query language                                                      |
| PromQL more complex querying possible   | only simple aggregations via API                                               |
| doesn't scale, must [Thanos](thanos.md) | scales much better using [HBase](hbase.md) for horizontal scaling and sharding |

## Collections Agents

Static binary - exposes port 9100 `/metrics` for scraping.

Collectd & Telegraf have Prometheus plugins that listen for `/metrics` scraping requests.

Systemd integration gives stats on processes:

```python
./node_exporter --collector.systemd
```

- Collectd port 9103 `/metrics`
- Telegraf port 9273 `/metrics`
- Docker 1.13+ port 4999 `/metrics`
  - set docker daemon flags:
    - daemon.json: `{ "metrics_addr": "0.0.0.0:9323", "experimental": true }`
      <br>or
    - `--experimental=true --metrics-addr=0.0.0.0:4999`

## Exporters

Download exporters from the Prometheus [Downloads](https://prometheus.io/download/) page.

Or quickly install the binaries for these exporters using the `install/install_prometheus_*.sh` scripts in the
[DevOps-Bash-tools](devops-bash-tools.md) repo.

### Node Exporter

:octocat: [prometheus/node_exporter](https://github.com/prometheus/node_exporter)

Prometheus Node Exporter is a popular way to collect system level metrics from operating systems, such as:

- CPU
- Disk
- Network
- Process stats

```shell
install_node_exporter.sh
```

Run `--help` to see its options:

```shell
node_exporter --help
```

```shell
node_exporter
```

Listens on port 9100.

See :octocat: [prometheus/node_exporter](https://github.com/prometheus/node_exporter) GitHub homepage above for the list of different stats to enable / disable.

**Import the ready-made dashboard for [Node Exporter](https://grafana.com/grafana/dashboards/1860-node-exporter-full/)
dashboard into [Grafana](grafana.md).**

[YouTube - Monitoring Linux Host Metrics with Prometheus \| Node Exporter (Setup, Scrape, Query, Grafana)](https://www.youtube.com/watch?v=dcb59H_iLj4)

### Blackbox Exporter

:octocat: [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter)

Endpoint monitoring for uptime and availability metrics by probing of endpoints over HTTP(S), DNS, TCP, ICMP and gRPC.

```shell
install_prometheus_blackbox_exporter.sh
```

**TODO: revision control configuration**

### Consul Exporter

:octocat: [prometheus/consul_exporter](https://github.com/prometheus/consul_exporter)

```shell
install_prometheus_consul_exporter.sh
```

### Graphite Exporter

:octocat: [prometheus/graphite_exporter](https://github.com/prometheus/graphite_exporter)

```shell
install_prometheus_graphite_exporter.sh
```

### Memcached Exporter

:octocat: [prometheus/memcached_exporter](https://github.com/prometheus/memcached_exporter)

```shell
install_prometheus_memcached_exporter.sh
```

### MySQLd Exporter

:octocat: [prometheus/mysqld_exporter](https://github.com/prometheus/mysqld_exporter)

```shell
install_prometheus_mysqld_exporter.sh
```

### Statsd Exporter

:octocat: [prometheus/statsd_exporter](https://github.com/prometheus/statsd_exporter)

```shell
install_prometheus_statsd_exporter.sh
```

### Kube State Metrics

Kube State metrics is a service that talks to the Kubernetes API server to get all the details about all the API objects like deployments, pods, daemonsets, Statefulsets, etc.

### Ccloud Exporter

:octocat: [Dabz/ccloudexporter](https://github.com/Dabz/ccloudexporter)

Confluent Cloud Exporter - exports metrics from Confluent Cloud Metric API on port 2122

### Confluent Connector

### ArgoCD Metrics

<https://argo-cd.readthedocs.io/en/stable/operator-manual/metrics/>

Capture the lag for each consumer offsets on different environments and alert when lag is more than 100.

### JMX Exporter

[:octocat: prometheus/jmx_exporter](https://github.com/prometheus/jmx_exporter)

### SNMP Exporter

[:octocat: prometheus/snmp_exporter](https://github.com/prometheus/snmp_exporter)

### Kafka-lag Exporter

[:octocat: seglo/kafka-lag-exporter](https://github.com/seglo/kafka-lag-exporter)

### Airflow Exporter

<https://pypi.org/project/airflow-exporter/>

## Alert Manager

:octocat: [prometheus/alertmanager](https://github.com/prometheus/alertmanager)

The Alert Manager handles alerts sent by client applications such as the Prometheus server.

It takes care of deduplicating, grouping, and routing them to the correct receiver integration such as email, PagerDuty, or OpsGenie. It also takes care of silencing and inhibition of alerts.

Alert Manager can be run in HA mode to ensure alerts are not missed.

```shell
install_prometheus_alertmanager.sh
```

## Push Gateway

:octocat: [prometheus/pushgateway](https://github.com/prometheus/pushgateway)

```shell
install_prometheus_push_gateway.sh
```

## PromLens

<https://promlens.com/>

:octocat: [prometheus/promlens](https://github.com/prometheus/promlens)

Web-based query builder for [PromQL](#promql).

Quickly install the binary using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_promlens.sh
```

Run `--help` to see its options:

```shell
promlens --help
```

## Resources

[Prometheus Docs](https://prometheus.io/docs)

[PromLabs YouTube](https://www.youtube.com/@PromLabs)

<https://www.youtube.com/@PromLabs/videos>

<https://training.promlabs.com/>

**Ported from private Knowledge Base page 2016+**
