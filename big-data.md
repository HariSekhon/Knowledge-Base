# Big Data



## Apache Beam

https://beam.apache.org/

- analytics abstraction layer
- engine backends to:
  - Spark
  - Flink
  - Apex
  - Google Cloud DataFlow
- APIs:
  - Python
  - Java

## Druid DB

See also: Pivot - an exploratory analytics UI for Druid

- OLAP ad-hoc interactive low latency queries "slice-n-dice"
- inverted index for needle-in-a-haystack queries
- columnar DB
- optimized for scans
- real-time ingest
- fast aggregation + ingest
- rollups on ingest (may reduce storage by 100x)
- schema required (for roll-ups)
- does not support full-text search like Elasticsearch
- use Spark to process and upload results to Druid
- doesn't support full joins (only large to small table joins)


###### Ported from various private Knowledge Base pages 2010+
