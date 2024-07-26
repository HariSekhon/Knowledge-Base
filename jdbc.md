# JDBC - Java DataBase Connect

Java driver standard to connect to databases.

Frequently used with RDBMS databases such as MySQL and PostgreSQL.

For Data Integration software such as [Informatica](informatica.md) or [Sqoop](sqoop.md) this typically requires
downloading the JDBC driver jar file for the specific database and then copying it into the 3rd party drivers directory
of the software to pick it up and use it.

## Download JDBC Jar

- [MySQL](#mysql)
- [PostgreSQL](#postgresql)

### MySQL

<https://dev.mysql.com/downloads/connector/j/>

Or

Quickly download and extract the jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_mysql_jdbc_jar.sh
```

The connection string should look like this:

```
jdbc:mysql://x.x.x.x:3306/my-db?useSSL=false
```

The `useSSL=false` setting is often needed for the connection to succeed as most databases haven't SSL configured on
their ports.

See also [MySQL](mysql.md) notes.

### PostgreSQL

<https://jdbc.postgresql.org/download/>

Or

<https://github.com/pgjdbc/pgjdbc/releases>

Or

Quickly download the latest jdbc jar using this script in [DevOps-Bash-tools](devops-bash-tools.md):

```shell
download_postgresql_jdbc_jar.sh
```

See also [PostgreSQL](postgres.md) notes.

### AWS Aurora JDBC

This JDBC wrapper works with MySQL and PostgreSQL JDBC drivers to support clustering

<https://github.com/aws/aws-advanced-jdbc-wrapper>
