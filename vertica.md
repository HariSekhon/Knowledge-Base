# HP Vertica

Proprietary MPP SQL OLAP database with a free community edition.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Vertica Client](#vertica-client)
  - [Install](#install)
  - [Client Locale](#client-locale)
- [Queries](#queries)

<!-- INDEX_END -->

## Key Points

- OLAP - online analytic processing (batch analytics, not real time)
- columnar database
  - high compression because columns of same data type compress better
  - enhanced query performance for well targeted sequential queries due to column read skipping at the expense of single record retrieval
- MPP - massively parallel processing architecture allows to scale horizontally across independent servers
  - segmentation into sub-clusters - on any integer column / expression - shards to nodes
    - local segmentation within a node to allow it to migrate that segment range of rows to another node
  - partitioning
- data replication and server recovery
  - hybrid storage
    - Write-optimized store (WOS) - in-memory, unsorted, uncompressed - mover to write to the ROS below
    - Read-optimized store (ROS) - 1 data file on disk for each column
    - projections storing data in different ways for optimization
- SQL + many analytics support
  - including windowing, pattern matching, time series
  - ML algorithms included eg. linear regression, logistic regression, k-means clustering, Naive Bayes classification,
    random forest decision trees, XGBoost, and support vector machine regression and classification
- Resource Pool Parameters for query optimization:
  - memory size
  - planned concurrency
  - max concurrency
  - execution parallelism
  - uses the above to allocate a query budget
  - create different pools with different query budgets for different query profiles
- integrates with Apache Spark, HDFS, and Kafka for streaming data ingestion
- Docker support:
  - <https://hub.docker.com/r/dataplatform/docker-vertica/> (old version 9.0.0 community edition)
- Kubernetes support: (version 10.1.1 onwards)
  - [:octocat: vertica/vertica-kubernetes](https://github.com/vertica/vertica-kubernetes)
- also integrates with Grafana, Helm, Go, and Distributed R
- Python library: [:octocat: vertica/vertica-python](https://github.com/vertica/vertica-python)
- Golang library: [:octocat: vertica/vertica-sql-go](https://github.com/vertica/vertica-sql-go)

## Vertica Client

### Install

From [DevOps-Bash-tools](devops-bash-tools.md) use these automated install scripts.

These scripts will automatically determine the latest version if none is specified.

Installs `vqsl` binary to `/usr/local/bin/` or `$HOME/bin` depending on your permissions:

```shell
install_vertica_vsql_client.sh  # <version>
```

Installs `vqsl` binary to `/opt/vertica/bin`:

```shell
install_vertica_vsql_client_rpm.sh  # <version>
```

Install the FIPS compliant RPM to `/opt/vertica` same as above rpm:

```shell
FIPS=true install_vertica_vsql_client_rpm.sh  # <version>
```

### Client Locale

The `vsql` client may fail to run if the locale isn't set correctly.

If you encounter a locale error when running it, put this in your `$HOME/.bashrc`:

```shell
export LC_ALL="C.UTF-8"
```

## Queries

```sql
SELECT
  transaction_id, path_line
FROM
  v_monitor.query_plan_profiles
```
