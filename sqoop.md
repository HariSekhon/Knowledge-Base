# Sqoop - SQL-to-Hadoop

Imports / Exports data tables between SQL DBs and Hadoop.

<!-- INDEX_START -->

- [Sqoop1](#sqoop1)
- [Sqoop2](#sqoop2)
- [Old Notes](#old-notes)
- [3rd party connectors](#3rd-party-connectors)
- [Custom Connectors](#custom-connectors)
  - [Teradata Connector for Hadoop](#teradata-connector-for-hadoop)
  - [SQL Server](#sql-server)
  - [Oracle](#oracle)
  - [Netezza](#netezza)
  - [Sybase IQ (formerly Olive)](#sybase-iq-formerly-olive)
  - [Informix](#informix)
- [Password Management](#password-management)
  - [Hadoop CredentialProvider API (Hadoop 2.6+)](#hadoop-credentialprovider-api-hadoop-26)
- [Incremental Imports](#incremental-imports)
- [Backups](#backups)
- [Troubleshooting](#troubleshooting)
- [Other](#other)

<!-- INDEX_END -->

## Sqoop1

- started as MySQL only in a week's hackathon session
- Map only job
- 4 maps by default (configurable)
- not good enough option checking
- DOA for banks due to passing cleartext authentication strings
- import sql tables to text/sequence files in HDFS in format `<directory>/part-m-0000[0-3]` - the 0-3 file naming is because of the default 4 mappers, with each one writing one output file
- defaults to CSV format
- uses [JDBC](jdbc.md) - should work with any JDBC compatible database
- incremental data imports, first run imports all rows, subsequent runs imports just rows changed since last import

## Sqoop2

- server + client
- server contains creds + accesses database + submits MR job
- web UI will grey out mutex options
- make web UI give CLI line
- separated authentication, connection object passing not finished yet

## Old Notes

Here for posterity, may not be up to date.

```properties
creds="--username hari --password somepassword"
```

use `--where` clause:

```shell
sqoop list-databases --connect jdbc:mysql://localhost
```

```shell
sqoop list-tables --connect jdbc:mysql://localhost/movielens
```

```shell
sqoop import --connect jdbc:mysql://localhost/movielens --table movie --fields-terminated-by '\t' $creds
```

if all `NULL`s in table serialization/termination use Control-A character see
<http://sqoop.apache.org/docs/1.4.3/SqoopUserGuide.html>:

```none
  --fields-terminated-by '\0001'
```

Create hive metadata `CREATE TABLE` when importing based on the table definition from the RDBMS:

```shell
sqoop create-hive-table
```

```shell
sqoop import-all-tables
```

Sqoop 1.4.3 in IBM BigInsights 2.1.2 doesn't support `--hive-database`:

```none
  --mapreduce-job-name
  --delete-target-dir
```

For ORC support use HCatalog switches.

## 3rd party connectors

Only need to be added to machines that launch sqoop job.

Add to `sqoop/conf/managers.d/connectors`:

```properties
com.cloudera.sqoop.manager.NetezzaManagerFactory=/usr/lib/sqoop-nz-connector-1.1.1/sqoop-nz-connector-1.1.1.jar
```

or

Drop 3rd connector jars in one of these depending on RPM vs Parcel deployments:

```none
/usr/lib/sqoop/lib
```

Or

```none
/opt/cloudera/parcels/CDH/lib/sqoop/lib
```

Or Better - put in a dir and the link to the parcel subdir so it's a quick relink after parcel upgrades:

```shell
ll /usr/lib/sqoop-3rd-party-libs/
```

```
  total 7944
  -rwxr-xr-x. 1 root  root   823551 Jan 16  2013 ifxjdbc.jar
  -rwxr-xr-x. 1 root  root    45038 Jan 16  2013 ifxjdbcx.jar
  -rwxr-xr-x. 1 root  root  1585532 Jan 16  2013 ifxlang.jar
  -rwxr-xr-x. 1 root  root   307429 Jan 16  2013 ifxlsupp.jar
  -rwxr-xr-x. 1 root  root   806318 Jan 16  2013 ifxsqlj.jar
  -rwxr-xr-x. 1 root  root    48982 Jan 16  2013 ifxtools.jar
  -rw-rw-r--. 1 anc17 anc17  603091 Oct 14 15:55 jconn4.jar
  -rw-r--r--. 1 root  root   822237 Sep 10  2012 mysql-connector-java-5.1.21.jar
  lrwxrwxrwx. 1 root  root       47 Nov  8  2012 mysql-connector-java.jar -> /usr/share/java/mysql-connector-java-5.1.21.jar
  -rw-rw-r--. 1 anc17 anc17  323520 Nov 27 09:51 nzjdbc.jar
  -rw-r--r--. 1 root  root  2714189 Mar  4  2013 ojdbc6.jar
  -rwxrwxr-x. 1 anc17 anc17   36300 Nov 27 11:36 sqoop-nz-connector-1.1.1.jar
```

## Custom Connectors

Any [JDBC](jdbc.md) driver.

3rd party partners, not open source but freely provided:

- Netezza
- Teradata
- Oracle (partner Quest Software)
- DataDirect - proprietary SQL Server ODBC/JDBC with NTLM authentication from Linux

Now has connectors for HBase and Accumulo?

### Teradata Connector for Hadoop

Sqoop add-on which give `sqoop tdimport` and `sqoop tdexport` commands

### SQL Server

```none
sqljdbc4.jar
```

Sqoop parameters:

```none
  --connect "jdbc:sqlserver://${HOST}:${PORT};database=${DB}"
  --driver com.microsoft.sqlserver.jdbc.SQLServerDriver
```

### Oracle

`USER/SCHEMA` & `PASSWORD` must be uppercase otherwise misleading error: `no columns found`

```shell
ojdbc6.jar
```

Sqoop parameters:

```none
  --connect "jdbc:oracle:thin:@//${HOST}:${PORT}/${DB}"
```

### Netezza

3rd party connector, not the Cloudera connector

```none
  --connect "jdbc:netezza://${HOST}:${PORT}/${DB}"
  --driver  org.netezza.Driver
```

### Sybase IQ (formerly Olive)

```shell
  --connect "jdbc:sybase:Tds:${HOST}:${PORT}/${DB}"
  --driver  com.sybase.jdbc4.jdbc.SybDriver
```

### Informix

```shell
  --connect "jdbc:informix-sqli://${HOST}:${PORT}/${DB}:informixserver=sb_dr_tcp"
  --driver  com.informix.jdbc.IfxDriver
```

There was a total Informix DB outage, which resulted in a misleading error implying incorrect driver / missing sqoop lib
although the libs were there unchanged the whole time:

```none
14/01/29 05:04:47 WARN sqoop.ConnFactory: Parameter --driver is set to an explicit driver however appropriate connection manager is not being set (via --connection-manager). Sqoop is going to fall back to org.apache.sqoop.manager.GenericJdbcManager. Please specify explicitly which connection manager should be used next time.
```

## Password Management

`--password $PASSWORD` will still expose `--password MySecret` in the process list for all users to see.

Read password from the console

```shell
  -P
```

file can be local `file://` or `hdfs://` (default = hdfs)

```shell
chmod 0400 .passwd
```

```none
  --password-file ${user.home}/.passwd
```

### Hadoop CredentialProvider API (Hadoop 2.6+)

Generate keystore:

```shell
hadoop credential create myPwAlias -provider jceks://path/file.jks
```

```
Enter password:
Enter password again:
myPwAlias has been successfully created
org.apache.hadoop.security.alias.JavaKeyStoreProvider has been updated
```

```shell
hadoop credential list -provider jceks://path/file.jks
```

```shell
sqoop import -Dhadoop.security.credential.provider.path=jceks://path/file.jks --password-alias myPwAlias
```

Final Unofficial Solution not in docs:

```java
public class MyPasswordLoader extends PasswordLoader {
  @Override
  public String loadPassword(String p, Configuration configuration) throws IOException {
    return myKeyStore.getPassphrase()
  }
}
```

Options File:

```shell
sqoop --options-file /path/file.txt ...
```

`file.txt`:

```
Import
--connect
jdbc:mysql://<host>/<db>
--username
hari
--password
somepassword
```

## Incremental Imports

By default sqoop doesn't store passwords in the metastore. To enable password storage, the following configuration has
to be added to `conf/sqoop-site.xml`:

```
sqoop.metastore.client.record.password = true
```

Similarly, `--meta-connect` can be omitted by adding the following to the `conf/sqoop-site.xml` file:

```shell
sqoop.metastore.client.autoconnect.url = <--meta-connect url>
```

```shell
ssh sqoop@metaserver
```

```shell
nohup sqoop metastore &
```

```shell
sqoop metastore --shutdown
```

```shell
sqoop job   --import  \
  --create myImport  \
  --meta-connect 'jdbc:hsqldb:hsql://metaserver:16000/sqoop'   \
  --connect jdbc:informix-sqli://x.x.x.x:9070/<dbname>:informixserver=sb_dr_tcp  \
  --driver com.informix.jdbc.IfxDriver  \
  --table <tablename>         \
  --username <user>           \
  --password <password>       \
  --check-column '<column>'   \
  --incremental append        \
  --last-value 6377740000     \
  --num-mappers 20            \
  --split-by '<column>'       \
  --hbase-table '<tblname>'   \
  --column-family 'cf1'       \
  --hbase-row-key '<key>'
```

Sqoop import to dynamic partitions via HCatalog.

## Backups

- job metadata (last record processed sequence/timestamp, job name etc) stored in HSQLDB file on disk
  - while some in memory data is not flushed to disk there is potential data loss
  - back up HSQLDB + store sqoop metadata for example incremental loads (last load sequence, timestamp etc) in hdfs or in hive/hbase for 100% recovery

## Troubleshooting

```java
java.io.IOException permission denied org.apache.hadoop.fs.FileSystem.mkdir
```

Fix - create home directory for `/user/$user` in HDFS.

## Other

<https://www.dezyre.com/article/sqoop-interview-questions-and-answers-for-2016/274>

**Ported from private Knowledge Base page 2013**
