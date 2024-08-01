# SQL

## SQL Scripts

Scripts for [PostgreSQL](postgres.md), [MySQL](mysql.md), AWS Athena and Google BigQuery:

[HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts)

## RBDMS SQL Databases

### Open Source Databases

- [MySQL](mysql.md) - easy to use with easy DB replication features
- [PostgreSQL](postgres.md) - high quality open source database - the natural open source choice to move away from
  Oracle (one company where I was a semi Oracle DBA for a few years did exactly this migration after my time)

#### Small Embedded DBs

Useful for local or embedded usage rather than multi-user servers like most major RDBMS systems.

- [SQLite](https://www.sqlite.org/) - small fast local SQL DB that can store data in a simple file
  [.sqliterc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.sqliterc) config is available in the
  [DevOps-Bash-tools](devops-bash-tools.md) repo
- [DuckDB](https://duckdb.org/) - single process local SQL DB akin to SQLite with minimal dependencies

### Cloud Databases

- [AWS Redshift](https://aws.amazon.com/redshift/) - managed SQL cluster,
  built on [ParAccel](https://en.wikipedia.org/wiki/ParAccel)
  MPP columnar DB built on PostgreSQL, charges on a VMs running basis
- [AWS Athena](https://aws.amazon.com/athena/) - serverless DB that operates on AWS S3 files or various data formats
  and charges by query
- [GCP BigQuery](https://cloud.google.com/bigquery/) - serverless DB that charges by query

### Proprietary / Legacy Databases

- [Oracle](https://www.oracle.com/) - an OG of RDBMS databases with good performance, durability and PL/SQL advanced SQL
  dialect. Notoriously expensive
- [Microsoft SQL Server](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) - slightly more user friendly
  than Oracle, with Transact SQL aka TSQL
- [Netezza](https://www.ibm.com/products/netezza) - specialist rack appliance, even more expensive than Oracle

## SQL Clients

Preference is given to free tools.

- [DBeaver](https://dbeaver.io/)
- [CloudBeaver](cloudbeaver.md) - web UI SQL client
- [DBGate](https://dbgate.org/) - SQL + NoSQL client
- [BeeKeeperStudio](https://www.beekeeperstudio.io/)
- [SQLectron](https://github.com/sqlectron/sqlectron-gui) - lightweight client
- [HeidiSQL](https://www.heidisql.com/)
- [DBVisualizer](https://www.dbvis.com/)
- [SQuirreL](https://squirrel-sql.sourceforge.io/)
- [Tora](https://github.com/tora-tool/tora/wiki)
- [PgAdmin](https://www.pgadmin.org/) - PostgreSQL web UI
- [phpMyAdmin](https://www.phpmyadmin.net/) - MySQL web UI
- [SQL Chat](https://github.com/sqlchat/sqlchat) - chat-based interface to querying DBs

## SQL Joins

![](https://media.licdn.com/dms/image/D5622AQGSP8OYFxOSaA/feedshare-shrink_2048_1536/0/1718097295510?e=1721865600&v=beta&t=Z2JCgUx04L5isIdQ1b7xb9_jywoUAKPn5G6Uwhbzg1E)
