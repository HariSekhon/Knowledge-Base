# HP Vertica

Proprietary MPP SQL OLAP database with a free community edition.

<!-- INDEX_START -->
<!-- INDEX_END -->

## Summary

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
  - <https://github.com/vertica/vertica-kubernetes>
- also integrates with Grafana, Helm, Go, and Distributed R
- Python library: <https://github.com/vertica/vertica-python>
- Golang library: <https://github.com/vertica/vertica-sql-go>

## Queries

```sql
SELECT
  transaction_id, path_line
FROM
  v_monitor.query_plan_profiles
```
