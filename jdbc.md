# JDBC - Java DataBase Connect

Java driver standard to connect to databases.

Frequently used with RDBMS databases such as MySQL and PostgreSQL.

<!-- INDEX_START -->

- [Installation](#installation)
  - [IP Addresses vs DNS FQDNs](#ip-addresses-vs-dns-fqdns)
- [MySQL](#mysql)
- [PostgreSQL](#postgresql)
- [AWS Aurora JDBC](#aws-aurora-jdbc)
- [Microsoft SQL Server](#microsoft-sql-server)
- [Vertica](#vertica)

<!-- INDEX_END -->

## Installation

For Data Integration software such as [Informatica](informatica.md) or [Sqoop](sqoop.md) this typically requires
downloading the JDBC driver jar file for the specific database and then copying it into the 3rd party drivers directory
of the software to pick it up and use it.

### IP Addresses vs DNS FQDNs

While hostname in the JDBC connection string examples below are shown as an `x.x.x.x` IP address for simplicity,
you should probably replace them with a DNS FQDN instead of an IP address in order to track failovers in
High Availability systems like AWS RDS.

## MySQL

<https://dev.mysql.com/downloads/connector/j/>

Quickly download and extract the jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_mysql_jdbc_jar.sh
```

JDBC driver class name:

```java
com.mysql.jdbc.Driver
```

JDBC connection string example:

```text
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

JDBC driver class name:

```java
org.postgresql.Driver
```

JDBC connection string example:

```java
postgresql://x.x.x.x:5432/MY-DB?sslmode=disable
```

See also [PostgreSQL](postgres.md) notes.

## AWS Aurora JDBC

This JDBC wrapper works with MySQL and PostgreSQL JDBC drivers to support clustering

[:octocat: aws/aws-advanced-jdbc-wrapper](https://github.com/aws/aws-advanced-jdbc-wrapper)

## Microsoft SQL Server

<https://learn.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server?view=sql-server-ver16>

[:octocat: microsoft/mssql-jdbc](https://github.com/microsoft/mssql-jdbc)

Quickly download the latest jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_mssql_jdbc_jar.sh
```

JDBC driver class name:

```java
com.microsoft.sqlserver.jdbc.SQLServerDriver
```

JDBC connection string example:

```java
jdbc:sqlserver://x.x.x.x:1433;databaseName=MY-DB;user=MY-USER;password=MY-PASSWORD;encrypt=false
```

## Vertica

<https://www.vertica.com/download/vertica/client-drivers/>

<https://docs.vertica.com/23.4.x/en/connecting-to/client-libraries/client-drivers/install-config/jdbc/installing-jdbc/>

If you need a FIPS compliant driver:

<https://docs.vertica.com/23.4.x/en/connecting-to/client-libraries/client-drivers/install-config/fips/installing-fips-client-driver-jdbc/>

Quickly download the latest jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_vertica_jdbc_jar.sh
```

JDBC driver class name:

```java
com.vertica.jdbc.Driver
```

JDBC connection string example:

```java
jdbc:vertica://x.x.x.x:5433/MY-DB?ssl=false
```
