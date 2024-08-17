# Presto

Presto SQL by Facebook

backed by Teradata from mid 2015

[Starburst](https://www.starburst.io/) - company backing Presto spun out from Teradata.

[PrestoSQL.io](https://prestodb.io/) community replacing Facebook [PrestoDB.io](https://prestodb.io/)

- written in Java

- 2-7.5x faster than [Hive](hive.md), 4-7x more CPU efficient

<!-- INDEX_START -->
- [Summary](#summary)
- [Instant Presto using Docker](#instant-presto-using-docker)
- [High Availability](#high-availability)
- [Access Control](#access-control)
- [Coordinators](#coordinators)
- [Workers](#workers)
- [Connectors](#connectors)
  - [Connector List](#connector-list)
- [Catalog](#catalog)
- [Logs](#logs)
- [Presto Verifier](#presto-verifier)
- [Benchmark Tool](#benchmark-tool)
- [Python library](#python-library)
- [Setup](#setup)
- [Configs](#configs)
- [set false on just workers](#set-false-on-just-workers)
- [might want to set false on dedicated coordinators](#might-want-to-set-false-on-dedicated-coordinators)
- [tune this according to -Xmx in jvm.config](#tune-this-according-to--xmx-in-jvmconfig)
- [must not end in a slash](#must-not-end-in-a-slash)
- [metrics monitoring](#metrics-monitoring)
- [Debug Krb using these in jvm.config](#debug-krb-using-these-in-jvmconfig)
- [for HDFS HA setups add:](#for-hdfs-ha-setups-add)
- [this config must be on all presto nodes, as must the hadoop conf files](#this-config-must-be-on-all-presto-nodes-as-must-the-hadoop-conf-files)
- [no authz in Presto yet so need to use HDFS ACLs and impersonation](#no-authz-in-presto-yet-so-need-to-use-hdfs-acls-and-impersonation)
- [_HOST will be auto-replaced by the hostname of the Presto worker](#host-will-be-auto-replaced-by-the-hostname-of-the-presto-worker)
- [API](#api)
- [Presto SQL](#presto-sql)
<!-- INDEX_END -->

## Summary

- OLAP for data warehousing
- not OLTP
- uses [Hive](hive.md) Metastore
- external data sources eg. [Cassandra](cassandra.md)
- ANSI [SQL](sql.md)
- query federation via external catalogs
- CLI is self-executing jar, downloaded separately


- pipelined execution
- no wait time - starts all stages and streams data from one stage to another
- no fault tolerance
- no intermediate storage (all in memory)
- does not tolerate failures, queries will fail like [Impala](impala.md) / [Drill](drill.md) etc no time to recover
- joining 2 tables, one must fit in memory


- HTTP for data transfer

| Port | Description                                                                                       |
| ---- |---------------------------------------------------------------------------------------------------|
| 8080 | - WebUI<br/>- inter-node communication<br/>- HTTP API (ODBC/[JDBC](jdbc.md) drivers use this too) |

## Instant Presto using Docker

This docker command pulls the docker image and runs a container dropping you into an SQL shell on a one node
Presto instance running in Docker:

```shell
docker run -ti harisekhon/presto
```

or

```shell
docker run -ti harisekhon/presto-dev
```

Then see the [Presto SQL](#presto-sql) section futher down.

See [DockerHub](https://hub.docker.com/u/harisekhon) for a selection of docker images - the Dockerfiles for
various Presto builds and other technologies can be found in the
[HariSekhon/Dockerfiles](https://github.com/HariSekhon/Dockerfiles) GitHub repo.

## High Availability

#### Coordinator has no in-built HA / fault tolerance

Run 2 coordinators and [Load Balance](load-balancing.md) with stickyness in front of multiple coordinator nodes
eg. using [HAProxy](haproxy.md)

#### In-flight queries will fail in event of Load Balancing failover

#### Inter-node communication is unauthenticated HTTP - does not support HTTPS or Kerberos!!

- Nodes communicate between each other using REST API
- Presto CLI, JDBC / ODBC drivers all use REST API

## Access Control

#### No authorization control, all or nothing per catalog (backend)

- separates authenticating user from authorized user,
  - requires customization to `SystemAccessControlFactory` and `ConnectorAccessControlFactory` for authorization
- [JDBC](jdbc.md) driver
- [Kerberos](kerberos.md) support
- Presto does not allow drop table if you are not the owner of the table

## Coordinators

- parses [SQL](sql.md)
- plans queries
- tracks query execution
- manages worker nodes
- communicates with workers via REST API
- fetches results from workers and returns them to client (bottleneck?!)

## Workers

- executes tasks
- fetches data from connectors
- exchange intermediate data with other workers
- advertises to discovery server in the coordinator
- communicates with other works and coorindators via REST API
- Yarn support via Slider

## Connectors

Connectors are pluggable interfaces to other sources.

The namespace becomes `<name>` from the file name and the connector type is taken from the file eg.

- multiple Hive clusters just different `etc/catalog/<name>.properties` files containing `connector.name=hive-hadoop2`


- HDFS - if not Krb will connect using OS user of Presto process
  - override in JVM Config with `-DHADOOP_USER_NAME=hdfs_user`

#### Kerberos ticket cache not supported yet - does this mean it kinit's before every request or at daemon startup?

### Connector List

- Hive (metastore)
- Local Files
- HDFS
- MySQL
- PostgresSQL
- Kafka
- Cassandra
- Redis
- AWS Redshift
- JMX periodic dumping
- MongoDB
- Accumulo
- Microsoft SQL Server

## Catalog

| Term      | Description                                               |
|-----------|-----------------------------------------------------------|
| Schema    | way to organize tables                                    |
| Catalog   | schema + reference to connector for data source           |
| Statement | textual SQL query                                         |
| Query     | config + components instantiated to execute the statement |

- multiple schemas can use same connector eg. query 2 Hive clusters in 1 query
- table names are fully qualified rooted to the catalog eg. `hive.<db>.<table>`
- ACLs are only all / read / file based / custom class:
  - `access-control.name=allow-all`
  - `access-control.name=read-only`
  - `access-control.name=file`
    - file method has `allow: true/false` for each catalog, json does not permit comments
      - `security.config-file=etc/rules.json`
  - MyCustomClass

## Logs

Main log:

```
server.log
```

Startup stdout/stderr log:

```
launcher.log
```

HTTP request log:

```
http-request.log
```

## Presto Verifier

<https://prestodb.io/docs/current/installation/verifier.html>

- set up a MySQL db table definition
- create `config.properties`

Download jar and run it:

```shell
wget presto-verifier-<version>-executable.jar -O verifier &&
chmod +x verifier
```

```shell
./verifier config.properties
```

## Benchmark Tool

<https://prestodb.io/docs/current/installation/benchmark-driver.html>

## Python library

- No Parquet support
- No local/embedded mode
- Supports formats: Text, SequenceFile, RCFile, ORC

- Connectors for Hive, Cassandra, JMX, Kafka, MySQL PostgreSQL, S3

## Setup

Recommended to use `presto-admin`

Download Teradata distribution server tarball, contains:

- `prestoadmin`
- `presto-server-rpm`
- `presto-cli-...-executable.jar`

`prestoadmin` online installer downloads from internet, more platform independent
offline installer is recommended cos faster

- uses paramiko SSH with keys or pw
- basically just copies RPM argument around and does start/stop, copy configs etc

## Configs

`etc/config.properties`:

```
# set false on just workers
coordinator=true
# might want to set false on dedicated coordinators
node-scheduler.include-coordinator=true
http-server.http.port=8080

# tune this according to -Xmx in jvm.config
query.max-memory=2GB
query.max-memory-per-node=512MB

discovery-server.enabled=true
# must not end in a slash
discovery.uri=http://localhost:8080

# metrics monitoring
jmx.rmiserver.port =

http-server.max-request.header-size=128KB

http-server.authentication=KERBEROS
http-server.authentication.krb5.service=presto
http.server.authentication.krb5.keytab=/etc/presto/presto.keytab
http.authentication.krb5.config=/etc/krb5.conf
http.server.authentication.keytabs=keytab1,keytab2
http.server.authentication.principals=HTTP/<fqdn>@REALM,HTTP/<fqdn>@REALM2

http-server.https.enabled=true
http-server.https.port=7778

http-server.https.keystore.path=/etc/presto_keystore.jks
http-server.https.keystore.key=changeit

# Debug Krb using these in jvm.config
-Dsun.security.krb5.debug=true
-dlog.enable-console=true
```


`etc/catalog/<name>.properties`:

```
connector.name=hive-hadoop2
hive.metastore.uri=thrift://<fqdn>:9083
hive.metastore-cache-ttl=30

# for HDFS HA setups add:
hive.config.resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
# this config must be on all presto nodes, as must the hadoop conf files

hive.metastore.authentication.type=KERBEROS
hive.hdfs.authentication.type=KERBEROS

# no authz in Presto yet so need to use HDFS ACLs and impersonation
hive.hdfs.impersonation.enabled=true

# _HOST will be auto-replaced by the hostname of the Presto worker
hive.metastore.service.principal=hive/_HOST@<REALM>
hive.metastore.client.principal=hive/_HOST@<REALM>
hive.metastore.client.keytab=/etc/security/keytabs/hive.service.keytab

hive.hdfs.presto.principal=hive/_HOST@<REALM>
hive.hdfs.presto.keytab=/etc/security/keytabs/hive.service.keytab
```

Presto `/etc/presto/catalog/postgres.properties`:

```
connector.name=postgresql
connection-url=jdbc:postgresql://<fqdn>/<db>?schema=<schema>
connection-user=hari
connection-password=test123
```

#### TODO: docker system connector

## API

Presto queries via HTTP API, sends to `/v1/statement` => follows 2nd URL href returned.

Would then have to poll that second ref for `operationalState` - if using API instead use `fetchall()` to block on query
completion and test status.

## Presto SQL

```sql
SHOW CATALOGS;
```

`USE` sets `<catalog>.<schema>` or `<catalog>` or just `<schema>`, so must `use <catalog>.<anything>` to set the catalog
before show schemas will work:

```sql
USE hive.blah
```

```sql
SHOW SCHEMAS;
```

```sql
SHOW TABLES FROM hive.default;
```

Variables:

```sql
SHOW SESSION;
```

```sql
USE memory.test;
```

Create table - can't use backticks, and no string type like hive:

```sql
CREATE TABLE test ("first" varchar(20));
```

#### TODO document show nodes, schemas, tables, kill queries etc

###### Partial port from private Knowledge Base page 2015+
