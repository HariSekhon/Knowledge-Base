# HP Vertica

MPP Proprietary SQL database with a free community edition.

- columnar database
  - high compression because columns of same data type compress better
  - enhanced query performance for well targeted sequential queries due to column read skipping at the expense of single record retrieval
- MPP - massively parallel processing architecture allows to scale horizontally across independent servers
- SQL + many analytics support
  - including windowing, pattern matching, time series
  - ML algorithms included eg. linear regression, logistic regression, k-means clustering, Naive Bayes classification,
    random forest decision trees, XGBoost, and support vector machine regression and classification
- data replication and server recovery
- integrates with Apache Spark, HDFS, and Kafka for streaming data ingestion
- Docker support:
  - https://hub.docker.com/r/dataplatform/docker-vertica/ (old version 9.0.0 community edition)
- Kubernetes support: (version 10.1.1 onwards)
  - https://github.com/vertica/vertica-kubernetes
- also integrates with Grafana, Helm, Go, and Distributed R
- Python library: https://github.com/vertica/vertica-python
- Golang library: https://github.com/vertica/vertica-sql-go
