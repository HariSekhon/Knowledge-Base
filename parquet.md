# Apache Parquet

Popular columnar data storage format, widely used in Big Data and Analytics.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Parquet Tools](#parquet-tools)
  - [Download](#download)
  - [Run](#run)
  - [Commands](#commands)
- [Hive Parquet Output](#hive-parquet-output)
- [Python Library - PyArrow](#python-library---pyarrow)
- [validate_parquet.py](#validate_parquetpy)

<!-- INDEX_END -->

## Key Points

- columnar
- efficient for column specific queries
- optimized for reads, more write overhead due to buffering (RAM+CPU)
- each data file contains the values for a set of rows
- schema evolution - limited - can only add columns at the end
- faster than [ORC](data-formats.md#orc)
- compression, different algos for different columns, eg. one type for string, another for numbers
- compression not as good as [ORC](data-formats.md#orc) but slightly faster
- widely used by many systems:
  - Databases-like systems, MPP, distributed SQL:
    - [Hive](hive.md)
    - [Impala](impala.md)
    - [Presto](presto.md)
    - [Apache Drill](drill.md)
    - [Trino](https://github.com/trinodb/trino)
  - Data processing frameworks:
    - [Spark](spark.md)
    - [Flink](https://flink.apache.org/)
    - [Pandas](https://pandas.pydata.org/)  (via PyArrow or FastParquet)
    - [Tensorflow](https://www.tensorflow.org/)
  - Cloud database warehousing platforms:
    - [Snowflake](snowflake.md)
    - [AWS Redshift](aws.md)
    - [AWS Athena](https://aws.amazon.com/athena/)
    - [Google BigQuery](bigquery.md)
    - [Google DataProc](https://cloud.google.com/dataproc)
    - [Azure Synapse Analytics](https://azure.microsoft.com/en-us/products/synapse-analytics)
    - [Azure Data Lake](https://azure.microsoft.com/en-us/solutions/data-lake)
    - [Databricks](https://www.databricks.com/)

## Parquet Tools

### Download

Download and install Parquet Tools from [here](https://repo1.maven.org/maven2/org/apache/parquet/parquet-tools/).

Or using script from [DevOps-Bash-tools](devops-bash-tools.md) which automatically determines latest version if no
version is specified as the first arg:

```shell
download_parquet_tools.sh  # "$version"
```

### Run

Run Parquet Tools jar, downloading it if not already present:

```shell
parquet_tools.sh <command>
```

You can run the jar directly, it's just a longer command:

```shell
PARQUET_VERSION="1.11.2"
```

```shell
java -jar "parquet-tools-$PARQUET_VERSION.jar" <command>
```

<!--

```shell
PARQUET_VERSION=1.5.0
```

```shell
cd /usr/local
wget -O "parquet-tools-$PARQUET_VERSION-bin.zip" \
  "http://search.maven.org/remotecontent?filepath=com/twitter/parquet-tools/$PARQUET_VERSION/parquet-tools-$PARQUET_VERSION-bin.zip"
unzip "parquet-tools-$PARQUET_VERSION-bin.zip"
link_latest parquet-tools-*
cd "parquet-tools-$PARQUET_VERSION"
```

Add the Parquet Tools to your `$PATH`:

```shell
export PATH="$PATH:/usr/local/bin/parquet-tools:$HOME/bin/parquet-tools"
```

-->

Then run the commands:

### Commands

```shell
parquet_tools.sh cat
```

```shell
parquet_tools.sh dump
```

```shell
parquet_tools.sh head
```

```shell
parquet_tools.sh meta
```

```shell
parquet_tools.sh schema
```

<!--

Old zip binary not available in versions > 1.6 (currently on 1.11.2)

```shell
parquet-cat
```

```shell
parquet-dump
```

```shell
parquet-head
```

```shell
parquet-meta
```

```shell
parquet-schema
```

```shell
parquet-tools --help
```

-->

## Hive Parquet Output

Hive creates parquet files as:

```text
/apps/hive/warehouse/bicore.db/auditlogs_parquet/000000_0
```

rather than:

```text
blah.parquet
```

## Python Library - PyArrow

```python
import pyarrow as pq
pq.read_table('file.parquet') # nthreads=4 optional argument
pr.ParquestDataset('myDir/') # nthread=4
```

Does not tolerate of errors though. See `validate_parquet.py` below.

## validate_parquet.py

Get it from [DevOps-Python-tools](devops-python-tools.md):

```shell
validate_parquet.py "$parquet_file" "$parquet_file2" ...
```

Recursively find and validate all parquet files in all directories under the current directory:

```shell
validate_parquet.py .
```

**Ported from private Knowledge Base page 2014+**
