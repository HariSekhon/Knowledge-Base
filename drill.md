# Apache Drill

<https://drill.apache.org/>

Open source distributed MPP columnar in-memory database that runs SQL-on-Hadoop or files.

<!-- INDEX_START -->

- [Key Points](#key-points)
  - [Data Support](#data-support)
  - [Drillbits](#drillbits)
  - [Drill Explorer](#drill-explorer)
  - [UDFs](#udfs)
  - [Query Execution](#query-execution)
    - [Query Parsing](#query-parsing)
  - [Drill Improvements Needed](#drill-improvements-needed)
- [Connectivity](#connectivity)
  - [Ports](#ports)
  - [HAProxy Configs](#haproxy-configs)
- [Storage Backends](#storage-backends)
- [Show All Queries in all Drillbit UIs](#show-all-queries-in-all-drillbit-uis)
- [Security](#security)
- [Install](#install)
  - [On MapR](#on-mapr)
  - [Embedded ZK mode](#embedded-zk-mode)
  - [Standalone Mode with a separate ZooKeeper host](#standalone-mode-with-a-separate-zookeeper-host)
  - [Distributed Mode with ZooKeeper Cluster](#distributed-mode-with-zookeeper-cluster)
  - [Distributed Mode](#distributed-mode)
- [Sample-data shipped with Drill](#sample-data-shipped-with-drill)
- [Custom Parsing](#custom-parsing)
- [Workspaces](#workspaces)
- [Conversion to Parquet](#conversion-to-parquet)
- [Convert JSON to CSV](#convert-json-to-csv)
- [Storage Plugins](#storage-plugins)
- [Troubleshooting](#troubleshooting)

<!-- INDEX_END -->

## Key Points

- Forked from MapR around Drill 0.6 / 0.7
- ANSI SQL 2003 or 2011 + extensions for nested data formats
- Calcite SQL parser
- read-only as of 0.6
- no `desc` SQL command as of 0.7
- 0.7 introduced multicast replacement, specify nodes for AWS
- 1.1+ SQL Windowing functions

- MPP - columnar execution in memory
  - optimized pipelined execution
  - late schema binding
    - schema changes during live query -> all operators reconfigure themselves
  - query optimizer pluggable rules + cost model at various stages of execution
    - storage plugins can expose rules to drill optimizer

  - vectorized CPU execution (simultaneous batches) to keep all CPU pipelines busy for efficiency
  - 256KB batch pipelines between nodes
  - only spills to disk on memory overflow
  - no query checkpointing - faster but query must user must retry query upon any node failure
  - no real scheduling
  - no concurrent resource management, Memory / CPU contention etc
    - limits query submissions but cannot calculate resources each query uses
    - can crash JVM OOM
- [HBase](hbase.md) storage plugin predicate push down to filter at HBase rather than retrieve all + then filter
- optimizer outputs Physical plan
- clients can give session / system options eg. which join algo or what parallelization to apply

### Data Support

- can run SQL queries directly on [JSON](json.md) data from json files under a directory
- rapidly evolve schema - auto-determines JSON schema on the fly
- `create view <select query>;` to allow SQL access to the data
- multi-source queries can combine different kinds of data sources in the same query
- schema can change over course of a query, operators designed to reconfigure themselves

### Drillbits

- Drillbit on every server (equivalent to an [Impala](impala.md) node)
- All drillbits are peers, same as Impala, connection node becomes the query planner
- Clients can connect directly to drillbit, but recommended to go via [ZooKeeper](zookeeper.md)
- node failure triggers query re-run

### Drill Explorer

Windows GUI app bundled with ODBC driver.

```cmd
C:\Program Files\MapR Drill Driver\lib\DrillExplorer.exe
```

- ODBC opts:
  - `QueryTimeout=180`
  - `HandShakeTimeout=5`

### UDFs

User defined functions.

- Dynamic UDFs - jars in `$CLASSPATH` - configure a dir for users to drop jars in to
- Manual UDFs - edit `module.conf`
- [Hive](hive.md) UDF jars

### Query Execution

#### Query Parsing

- `SQL Parser`
  - -> `Logical Plan`
    - -> `Rule` + `CBO Cost Based Optimizer`
      - -> `Physical Plan`
        - -> `EPF Execution Plan Fragments`
          - -> `nodes` (based on load etc)
            - -> [ZooKeeper](zookeeper.md) for the drillbit locations (bottleneck?)

- Root (Foreman) -> Intermediate nodes -> Leaf nodes
  - leaf nodes read + execute EPFs
  - intermediate nodes do partial aggregations as soon as receive from leaf
  - foreman - final aggregation + return to client

### Drill Improvements Needed

- query scheduling
- resource constraints
- in-flight query recovery
- no SQL Grants
- no column level security, only file level
  - MapR not gonna fix, believe ACLs should be done at storage layer
  - Workarounds:
    - Views - not recommended - giving Spark access later bypasses SQL layer column security as has to read files
    - use MapR-DB as Drill backend, has ACEs on CFs
- CSV - no header skipping support yet as of 1.1.0, see DRILL-624
- no DESCRIBE support for JSON/CSV/Parquet/MongoDB as of 1.1.0

## Connectivity

- HTTP UI
- [JDBC](jdbc.md) driver
- ODBC driver - not open source (Simba)

### Ports

| Port   | Description  |
|--------|--------------|
| 8047   | HTTP UI      |
| 31010  | JDBC / ODBC  |
| 31011  | Control port |
| 31012  | Data port    |

### HAProxy Configs

For load balancing the HTTP UI and JDBC / ODBC ports:

[HariSekhon/HAProxy-configs - apache-drill.cfg](https://github.com/HariSekhon/HAProxy-configs/blob/master/apache-drill.cfg)

[HariSekhon/HAProxy-configs - apache-drill-centralized-foreman.cfg](https://github.com/HariSekhon/HAProxy-configs/blob/master/apache-drill-centralized-foreman.cfg)

## Storage Backends

- Files:
  - JSON
  - CSV
  - Apache logs
- [Hive](hive.md)
- [HBase](hbase.md)
- MapR-DB
- [JDBC](jdbc.md) - RDBMS - MySQL, PostgreSQL, Oracle, SQL Server
- [AWS](aws.md) S3       (1.3+)
- [Kafka](kafka.md) 0.10+  (1.12+) - json messages
- [OpenTSDB](opentsdb.md) (1.12+) - lists metrics up to Integer.MAX -> use <opentsdb_name>; show tables;

## Show All Queries in all Drillbit UIs

Admin users get shutdown button in UI -> `Options` tab

Point pstore to HDFS / MapR-FS for UI on all nodes to show all queries

(defaults to local filesystem `/opt/mapr/drill/drill-<version>/logs/profiles`)

Add to `drill-override.conf`:

```conf
drill.exec {
  sys.store.provider.zk.blobroot: "maprfs:///apps/drill/pstore"
  "hdfs:///apps/drill/pstore"
}
```

or use HBase which should be more performant:

```conf
sys.store.provider: {
  class: "org.apache.drill.exec.store.hbase.config.HBasePStoreProvider",
    hbase: {
      table: "drill_store",
      config: {
      "hbase.zookeeper.quorum": "<ip>,<ip>,<ip>",
      "hbase.zookeeper.property.clientPort": "2181"
    }
  }
}
```

## Security

- [Kerberos](kerberos.md)
  - supports client encryption via SASL (Drill 1.11+)
- Plain - uses PAM
  - does not support client encryption

- no column-level security - views permissions are file-based ACE / ACLs
- use views to limit rows / columns
- hack: build CSV read into view to verify user in CSV for dynamic permissioning

- views - stored as a file in current workspace
  - only file-level permissions on <name>.view file
  - set max.chained.user.hops = 1 (default: 3)
  - no way to restrict view creation to admins only
  - no way to prevent users creating views then granting permissions to unauthorized users
  (would have to lock down to no hops for both admins + users)
  - limit data set to superuser + superuser create all views + max.chained.user.hops = 1

- cannot query Hive views, only tables (as of Drill 1.11 - early 2018)

- Chained Impersonation - view executes as view owner using max.chained.user.hops = 3
  - avoid this, use the below instead

- Inbound Impersonation - proxy_principals like Hadoop's proxyusers

`drill-override.conf`:

```config
drill.exec.impersonation.enabled: true
```

```sql
ALTER SYSTEM SET `exec.impersonation.inbound.policies`='[
  {
    proxy_principals:  { users: ["myServiceAccount"] },  # set 'users'
    target_principals: { users: ["*"] }                  #  or 'groups' for each
  },  # repeat these pairs as many times as needed
]';
```

```shell
bin/sqlline -u "jdbc:drill:schema=dfs;zk=myZkCluster;impersonation_target=hari" -u "myServiceAccount" -p "$password"
```

```sql
SELECT blah from <cluster>.<workspace>.<table_or_pattern> where blah > N;
```

```none
dfs       sub-dir     pattern
HBase
Hive      database    table
mongo     db          collection
```

```sql
SELECT name, flatten(fillings) AS f FROM dfs.users.`/donuts.json` WHERE f.cal < 300;
```

Interpret HBase data as JSON on the fly - `convert_from()` function is pluggable:

```sql
SELECT d.name, count(d.fillings) FROM ( SELECT convert_from(cf1.donut, json) AS d FROM hbase.user.`donuts` );
```

## Install

### On MapR

```shell
yum install -y mapr-drill
```

```shell
/opt/mapr/server/configure.sh -R -L /opt/mapr/configure-$(date '%F_%T').log
```

```shell
maprcli nodes services -name drill -start -nodes <list_of_nodes>
```

### Embedded ZK mode

```shell
sqlline -u "jdbc:drill:zk=local"
```

### Standalone Mode with a separate [ZooKeeper](zookeeper.md) host

```shell
sqlline -u "jdbc:drill:zk=$zookeeper_host"
```

### Distributed Mode with ZooKeeper Cluster

```shell
sqlline -u "jdbc:drill:[schema=<storage plugin>;]zk=<zk name>[:<port>][,<zk name2>[:<port>]... ]"
```

Can omit specifying `dfs.` storage plugin (must quote otherwise semicolon breaks the zk)
can still specify other storage plugins to query though such as:

```sql
cp.`employee.json`
```

```shell
sqlline -u "jdbc:drill:schema=dfs;zk=local"
```

Shortcut for `sqlline -u jdbc:drill:zk=local` available from 1.0 onwards

```shell
drill-embedded
```

```none
2015-07-17 14:15:47.381 java[48990:1877987] Unable to load realm info from SCDynamicStore
Jul 17, 2015 2:15:52 PM org.glassfish.jersey.server.ApplicationHandler initialize
INFO: Initiating Jersey application, version Jersey: 2.8 2014-04-29 01:25:26...
apache drill 1.0.0
"drill baby drill"
0: jdbc:drill:zk=local>
```

Configure via <http://localhost:8047/>

```sql
!set
!set maxwidth 10000
```

### Distributed Mode

Requires [ZooKeeper](zookeeper.md).

Configure `cluster-id` and `zk.connect`:

In `conf/drill-override.conf`:

```conf
drill.exec:{
  cluster-id: "<mydrillcluster>",
  zk.connect: "<zkhostname1>:<port>,<zkhostname2>:<port>,<zkhostname3>:<port>"
}
```

In `conf/drill-env.sh`:

```shell
planner.memory.max_query_memory_per_node
```

```shell
DRILL_MAX_DIRECT_MEMORY="8G" # will default to total system memory if not set
DRILL_MAX_HEAP="4G"

# uses vars above for -Xmx instead
export DRILL_JAVA_OPTS="..."
```

If performance is an issue, replace the `-ea` flag with `-Dbounds=false`, as shown in the following example:

```shell
drillbit.sh [--config <conf-dir>] (start|stop|status|restart|autorestart)
```

```shell
bin/drillbit.sh start
```

Finds Drill using ZooKeeper via `drill-override.conf`:

`drill-conf`

`drill-localhost`

```sql
SELECT * FROM sys.drillbits;
```

output:

```none
+-----------+------------+---------------+------------+----------+
| hostname  | user_port  | control_port  | data_port  | current  |
+-----------+------------+---------------+------------+----------+
| starfury  | 31010      | 31011         | 31012      | true     |
+-----------+------------+---------------+------------+----------+
```

```sql
SELECT * FROM sys WHERE name LIKE 'security.admin.users';
```

output:

```none
'security.admin.user_groups'
```

## Sample-data shipped with Drill

`cp` - the ClassPath plugin points to a JAR file in the Drill classpath that contains the Transaction Processing Performance Council (TPC) benchmark schema TPC-H that you can query.

```shell
SELECT * FROM cp.`employee.json` LIMIT 3;
```

```shell
SELECT * FROM dfs.`/usr/local/drill/sample-data/region.parquet`;
```

## Custom Parsing

`Storage` -> `DFS` -> `update` -> `formats` sections add:

```json
"hari": {
  "type": "text",
  "extensions": [ "txt" ],
  "quote": "~",
  "escape": "~",
  "delimiter": "^"
},
```

```shell
cd /tmp
wget https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR27/dnload/sr27asc.zip
unzip sr27asc.zip
```

## Workspaces

Workspaces are abbreviations to access files or tables.

`Storage Plugins` -> `DFS` -> `update` -> `workspace` section add:

```json
"hari": {
  "location": "/users/Hari/Downloads/drill-data",
  "writable": true,
  "storageformat": "parquet"
},
```

## Conversion to Parquet

Create a Parquet table from this weird delimited data,
writes the data to `Downloads/drill-nndb/<myTable>/0_0_0.parquet`.

Need to have configured DFS storage plugin to create a workspace with `writable => true` before you can write a table there which is Parquet by default

```sql
CREATE TABLE dfs.hari.myTable(col1, col2)
AS SELECT columns[0], columns[1] FROM dfs.tmp.`sr27asc/FOOD_DES.txt`;
```

## Convert JSON to CSV

Works nicely, requires `.json` file extension though, find file in `myDir/0_0_0.csv`.

```sql
USE dfs.hari;
ALTER SESSION SET `store.format`='csv';
CREATE TABLE dfs.hari.`myDir` AS SELECT * FROM dfs.hari.`my.json`;
```

Where there are multiple CSVs generated though some CSVs have some columns and others don't which makes it harder to
deal with them all together.

## Storage Plugins

Drill saves storage plugin configurations in a temporary directory (embedded mode) or in ZooKeeper (distributed mode).

Storage plugins:

- [Hive](hive.md) (metadata only, does not use Hive execution engine, uses data directly)
- [HBase](hbase.md)
- [Cassandra](cassandra.md)
- Kudu
- [MongoDB](mongo.md)

MongoDB 3.0

- read only

Load MongoDB test data set

```shell
wget -c "http://media.mongodb.org/zips.json"
```

Import to `tests.zips`:

```shell
mongoimport "zips.json"
```

<http://localhost:8047/storage> -> `mongo` -> `update` -> `change "enabled": true` -> `update`

```sql
SHOW DATABASES;
```

```sql
SHOW TABLES IN `dfs.default`;
```

```sql
SHOW TABLES IN sys;
```

```sql
SELECT * FROM sys.drillbits;
```

```sql
SELECT * FROM information_schema.columns WHERE TABLE = 'myTable';
```

default all queries to mongo storage plugin using 'use mongo'

doesn't seem to work, still need to prefix mongo otherwise get

```none
Jul 20, 2015 6:01:50 PM org.apache.calcite.sql.validate.SqlValidatorException <init>
SEVERE: org.apache.calcite.sql.validate.SqlValidatorException: Table 'test.zips' not found
Jul 20, 2015 6:01:50 PM org.apache.calcite.runtime.CalciteException <init>
SEVERE: org.apache.calcite.runtime.CalciteContextException: From line 1, column 15 to line 1, column 18: Table 'test.zips' not found
Error: PARSE ERROR: From line 1, column 15 to line 1, column 18: Table 'test.zips' not found
```

```none
[Error Id: 6b2dd038-af33-4466-930b-d58f0ad8e55d on starfury:31010] (state=,code=0)
```

```sql
USE mongo;
```

```sql
USE mongo.test;
SHOW TABLES;
```

```sql
SELECT * FROM mongo.test.zips;
```

```sql
SELECT COUNT(*) FROM zips
```

```sql
SELECT state,city,AVG(pop) FROM zips GROUP BY state,city;
```

```sql
SELECT loc FROM zips LIMIT 10;
```

select in to json list using array index notation:

```sql
SELECT loc[0] FROM zips LIMIT 10;
```

ETL mongo to parquet:

```sql
CREATE TABLE dfs.nndb.mongoZips AS SELECT * from mongo.test.zips;
```

There is no DROP table yet DRILL-3426 targeted 1.3+

Access embedded JSON fields via fully qualified table object reference

```sql
SELECT b.myField.subField FROM dfs.down.`my.json` b LIMIT 1;
```

## Troubleshooting

Drill Kerberos principals require host component eg. `drill/<cluster_name>@$REALM` not `drill@$REALM` which results in

```none
IllegalStateException empty name string
```

`drill-env.sh` - avoid:

```shell
DRILL_JAVA_LIB_PATH # use pam4j instead in drill-override.conf
MAPR_TICKETFILE_LOCATION=/tmp/mapruserticket_$UID
```

Drill:

```sql
SELECT * FROM dfs.`/tmp/test.dat`
```

```none
ERROR: VALIDATION ERROR: From line 1, column 17: Object '/tmp/test.dat' not found within 'dfs'
SQL Query null
```

**Fix:** caused by wrong filename extension, renaming to `test.csv` works.

```none
sqlline IllegalArgumentExeption - remove spaces in connection string!
```

If older Drill version is started against stale ZooKeeper from higher version (eg. Docker) it will error out with:

```none
Caused by: java.lang.RuntimeException: com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException: Unrecognized field "config" (class org.apache.drill.exec.store.dfs.FileSystemConfig), not marked as ignorable (4 known properties: "enabled", "formats", "connection", "workspaces"])
```

<https://issues.apache.org/jira/browse/DRILL-4383>

**Fix:** delete ZK and start fresh

**Ported from private Knowledge Base page 2014+**
