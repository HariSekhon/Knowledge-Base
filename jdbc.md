# JDBC - Java DataBase Connect

Java driver standard to connect to databases.

Frequently used with RDBMS databases such as MySQL and PostgreSQL.

<!-- INDEX_START -->

- [Installation](#installation)
- [MySQL](#mysql)
  - [JDBC Connection String](#jdbc-connection-string)
- [PostgreSQL](#postgresql)
- [AWS Aurora JDBC](#aws-aurora-jdbc)

<!-- INDEX_END -->

## Installation

For Data Integration software such as [Informatica](informatica.md) or [Sqoop](sqoop.md) this typically requires
downloading the JDBC driver jar file for the specific database and then copying it into the 3rd party drivers directory
of the software to pick it up and use it.

## MySQL

<https://dev.mysql.com/downloads/connector/j/>

Quickly download and extract the jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_mysql_jdbc_jar.sh
```

### JDBC Connection String

The connection string should look like this:

```none
jdbc:mysql://x.x.x.x:3306/MY-DB?useSSL=false
```

The `useSSL=false` setting is often needed for the connection to succeed as most databases don't have SSL
configured on their ports.

See also [MySQL](mysql.md) notes.

## PostgreSQL

<https://jdbc.postgresql.org/download/>

<https://github.com/pgjdbc/pgjdbc/releases>

Quickly download the latest jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_postgresql_jdbc_jar.sh
```

See also [PostgreSQL](postgres.md) notes.

## AWS Aurora JDBC

This JDBC wrapper works with MySQL and PostgreSQL JDBC drivers to support clustering

<https://github.com/aws/aws-advanced-jdbc-wrapper>

## Microsoft SQL Server

<https://learn.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server?view=sql-server-ver16>

<https://github.com/microsoft/mssql-jdbc>

Quickly download the latest jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_mssql_jdbc_jar.sh
```

```java
jdbc:sqlserver://x.x.x.x:1433;databaseName=MY-DB;user=MY-USER;password=MY-PASSWORD;encrypt=false;
```
