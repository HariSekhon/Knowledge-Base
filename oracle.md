# Oracle

<https://www.oracle.com/>

Widely used classic enterprise RDBMS databases with good performance, durability and PL/SQL advanced SQL.

Most of this was not retained to be ported and I don't work on Oracle any more to go back and populate this.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [AWS RDS Limitations](#aws-rds-limitations)
- [Install Oracle Client Packages - SQL*Plus, JDBC, ODBC, SDK](#install-oracle-client-packages---sqlplus-jdbc-odbc-sdk)
  - [SQL*Plus Readline Support](#sqlplus-readline-support)
- [Local Login as Admin](#local-login-as-admin)
- [Connecting to Oracle - TNS Listener & SID](#connecting-to-oracle---tns-listener--sid)
- [SQLcl command line client](#sqlcl-command-line-client)
  - [Features](#features)
  - [Install SQLcl](#install-sqlcl)
  - [SQLcl Config](#sqlcl-config)
  - [Using SQLcl - Tips & Tricks](#using-sqlcl---tips--tricks)
- [SQL Developer IDE](#sql-developer-ide)
  - [Install SQL Developer](#install-sql-developer)
  - [Using SQL Developer](#using-sql-developer)
    - [Execute Shortcut](#execute-shortcut)
- [SQL Scripts](#sql-scripts)
- [SQL](#sql)
  - [`dual` - the pseudo-table](#dual---the-pseudo-table)
  - [Get Date](#get-date)
  - [Get Oracle Version](#get-oracle-version)
  - [List Tablespaces](#list-tablespaces)
  - [List Tables](#list-tables)
  - [Count Tables per Tablespace](#count-tables-per-tablespace)
  - [List Users](#list-users)
  - [Show your Currently Connected Username](#show-your-currently-connected-username)
  - [Show Tables Owned by Currently Connected User](#show-tables-owned-by-currently-connected-user)
  - [Show the Privileges of the Currently Connected User](#show-the-privileges-of-the-currently-connected-user)
  - [Show Privileges of All Users](#show-privileges-of-all-users)
  - [Show Expired Passwords](#show-expired-passwords)
  - [Alter User Password](#alter-user-password)
  - [Show DB Configuration Parameters](#show-db-configuration-parameters)
  - [Get Table DDL](#get-table-ddl)
  - [Investigate table](#investigate-table)
  - [Backup Table to adjacent backup table](#backup-table-to-adjacent-backup-table)
- [Space Clean Up](#space-clean-up)
  - [Purge Recyclebin](#purge-recyclebin)
  - [Purge DBA Recyclebin](#purge-dba-recyclebin)
  - [Investigate Tablespaces Space](#investigate-tablespaces-space)
  - [Investigate Big Tables with Free Space](#investigate-big-tables-with-free-space)
  - [Shrink Table](#shrink-table)
  - [Shrink Tablespaces](#shrink-tablespaces)
    - [Shrink Permanent Tablespace](#shrink-permanent-tablespace)
      - [Big File Tablespace](#big-file-tablespace)
      - [Small File Tablespace](#small-file-tablespace)
    - [Shrink Temporary Tablespace](#shrink-temporary-tablespace)
- [Restore table from adjacent backup table](#restore-table-from-adjacent-backup-table)
- [Troubleshooting](#troubleshooting)
  - [Oracle Client Install `Error: Invalid version flag: or`](#oracle-client-install-error-invalid-version-flag-or)
  - [SQLcl Error: Could not find or load main class oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli](#sqlcl-error-could-not-find-or-load-main-class-oracledbtoolsraptorscriptrunnercmdlinesqlcli)

<!-- INDEX_END -->

## Key Points

- Expensive
- Widely used battle tested enterprise RDBMS
- Well suited to large-scale databases
- Good performance and optimizations
- Good security and encryption
- Cloud - available on major clouds as a managed database
  - eg. [AWS](aws.md) RDS, [GCP](gcp.md) Cloud SQL, [Azure](azure.md) Database
- PL/SQL - Procedural Language/Structured Query Language adds more programming logic as a superset of SQL
  - analogous to Microsoft SQL Server's T-SQL (Transact SQL)
- Oracle Autonomous Database automates tasks like tuning, backups, and patching using machine learning
- High Availability - RAC (Real Application Clusters) and Data Guard offer high availability and disaster recovery
- Clients - SQL*Plus, SQLcl, and SQL Developer for database management and development

| Port | Description       |
|------|-------------------|
| 1521 | Oracle SQL port   |

## AWS RDS Limitations

If you use Oracle on [AWS](aws.md) RDS then you'll face the following
[restrictions](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Oracle.Concepts.limitations.html#Oracle.Concepts.dba-limitations).

Including no use of these commands:

- `ALTER DATABASE`
- `ALTER SYSTEM`
- `CREATE ANY DIRECTORY`
- `DROP ANY DIRECTORY`
- `GRANT ANY PRIVILEGE`
- `GRANT ANY ROLE`

## Install Oracle Client Packages - SQL*Plus, JDBC, ODBC, SDK

<https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html>

If you have [DevOps-Bash-tools](devops-bash-tools.md) you can use this automated script below.

This will give you everything - SQL*Plus, JDBC, ODBC, SDK and Tools:

```shell
install_oracle_client.sh
```

If you get this RPM install error:

```text
Error: Invalid version flag: or
```

Install an older version.

See [Oracle Client Install Error](#oracle-client-install-error-invalid-version-flag-or)
in Troubleshooting section at end.

### SQL*Plus Readline Support

Use the `rlwrap` readline wrapper command in front of `sqlplus` to get command history:

```shell
rlwrap sqlplus <user>/<pass>@<fqdn>/<sid>
```

This is usually available in the `rlwrap` package on [RHEL](redhat.md) and [Debian](debian.md)-based Linux systems
and [brew](brew.md) on Mac.

## Local Login as Admin

This bypasses all authentication and logs you in as the superuser for administer the DB without needing a password.

First `su` to the `oracle` user under which Oracle was installed:

```shell
sudo su - oracle
```

Then as the `oracle` user start the local `sqlplus` client like this:

```shell
sqlplus / as sysdba
```

## Connecting to Oracle - TNS Listener & SID

Check the `TNS Listener` configuration for what `SID` the Oracle DB expects you to connect to otherwise it'll reject your
connection.

## SQLcl command line client

<https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/>

Newer much more user friendly CLI client from Oracle with 100 command history buffer.

Backwards compatible CLI options with classic SQL*Plus.

### Features

- edit multi-line statements and scripts interactively at the SQLcl prompt
- native [Liquibase](liquibase.md) integration, with automatic changelog generation for your Oracle Database objects
- 100 command history buffer
- auto-complete object names or keywords using the `<TAB>` key
- new commands: `CTAS`, `DLL`, `Repeat`, `ALIAS`, `SCRIPT`, `FORMAT` etc.
- client-side scripting - execute Javascript to manipulate query results, build dynamic commands, interact with the
  session etc.
- supports classic SQL*Plus environment settings, commands, and behaviours

### Install SQLcl

<https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/download/>

Quickly install using [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_oracle_sqlcl.sh
```

This will create a convenience stub script `/usr/local/bin/sqlcl`
pointing to `/usr/local/sqlcl/bin/sql` for `$PATH` convenience.

If you get an error running `sqlcl` or `/usr/local/sqlcl/bin/sql` like this:

```text
Error: Could not find or load main class oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli
Caused by: java.lang.ClassNotFoundException: oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli
```

This rather unintuitive message is caused by the stupid installation zip having `0640` octal permissions on
`sqlcl/lib/*` so if installed as root normal users not in the `wheel` group can run the `sql` but it can't find the
`lib/*.jar` files.

If you have installed via the [DevOps-Bash-tools](devops-bash-tools.md) scripted install `install_oracle_sqlcl.sh` you
shouldn't encounter this as it fixes the permissions at install time.

### SQLcl Config

<!--
Config file is found at (does this even work?):

```text
$HOME/.sqlcl/sqlrc
```

Doesn't work:

```properties
sqlcl.history.limit=1000
```

Doesn't show the size of the history buffer:

```sql
show history
```

-->

Show all settings:

```sql
show all
```

```sql
set ...
```

### Using SQLcl - Tips & Tricks

```shell
/usr/local/sqlcl/bin/sql <user>/<pass>@<fqdn>/<sid>
```

Inside SQLcl:

```sql
help
```

New commands are <u>underlined</u>.
<!-- <ins>underlined<ins> -->

`<TAB>` autocompletes column names.

Print the DDL for a table:

```sql
ddl <schema>.<table>
```

Options to customize DDL pretty output:

```sql
help set ddl
```

```sql
clear screen
```

Queries are smart formatted instead of column width to the definition like in SQL*Plus.

```sql
show sqlformat
```

To unset this to use the same old formatting as SQL*Plus:

```sql
set sqlformat
```

To output to CSV format (strings are quoted):

```sql
set sqlformat csv
```

Turn off column headers in the output:

```sql
set header off
```

Go back to using the nice smart formatting:

```sql
set sqlformat ansiconsole
```

```sql
set pagesize 50
```

Print the history list of last remembered 100 commands:

```sql
history
```

Go back to command number `<n>` as displayed from the `history` command:

```sql
history <n>
```

Execute it:

```sql
/
```

`INFO` is a new version of `DESCRIBE` that also shows Last Analyzed date-time, rows, sample size,
if table is inmemory enabled/disabled, comments on the table,
`*` next to the primary key, column comments, list of indexes, foreign key referential integrity constraints:

```sql
info <table>
```

Aliases for command queries or PL/SQL blocks with binds eg. `:days`:

```sql
alias list
```

```sql
alias list tomorrow
```

```sql
SELECT sysdate + :days from dual
```

Prints timestamp 7 days from now:

```sql
tomorrow 7
```

Repeat the last command 10 times, once every 1 second
(useful to watch sessions and SQL queries being sent or watch the status of an index rebuild):

```sql
repeat 10 1
```

## SQL Developer IDE

<https://www.oracle.com/database/sqldeveloper>

SQL Developer - free and widely used Oracle-specific IDE.

Alternatives:

- Toad for Oracle
- Navicat for Oracle
- generic [SQL Clients](sql.md#sql-clients)

### Install SQL Developer

[Download link](https://www.oracle.com/database/sqldeveloper/technologies/download/)

Quickly from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
install_oracle_sql_developer.sh
```

This will even auto-open it for you on Mac.

On Mac you can find this in your `Applications` pop-up menu along with the usual programs
or you can open it from the CLI using this command:

```shell
open -a "SQLDeveloper"
```

### Using SQL Developer

#### Execute Shortcut

Hit `Ctrl`-`Enter` on Windows or Mac when the cursor is on a query in the Query Builder SQL Worksheet to
quickly execute the SQL statement (must be ended with a semi-colon `;` to separate it from the next query)
without having to click the green triangle run button.

## SQL Scripts

Scripts for DBA administration and performance engineering:

[HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=SQL-scripts&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/SQL-scripts)

## SQL

### `dual` - the pseudo-table

If you want to `SELECT` a value from a function or built-in value that does require querying data from a real table or view, in Oracle you need to provide a fake pseudo-table called `DUAL` to pass the syntax check of the `SELECT` query, eg. when selecting the current date (see next section for example).

### Get Date

```sql
SELECT SYSDATE FROM dual;
```

### Get Oracle Version

```sql
SELECT * FROM v$version;
```

```text
Oracle Database 19c Standard Edition 2 Release 19.0.0.0.0 - Production
```

### List Tablespaces

```sql
SELECT tablespace_name, status, contents, logging FROM dba_tablespaces;
```

### List Tables

The `owner` is the schema, also known as the database in other RBDMS systems.

```sql
SELECT owner, table_name FROM dba_tables;
```

```sql
SELECT
    tablespace_name,
    table_name,
    status,
    pct_used,
    pct_free
FROM
    all_tables
WHERE
    tablespace_name NOT IN ('SYSTEM', 'SYSAUX', 'RDSADMIN')
ORDER BY
    tablespace_name, table_name;
```

### Count Tables per Tablespace

```sql
SELECT
    tablespace_name,
    count(1) as NUM_TABLES
FROM
    all_tables
GROUP BY
    tablespace_name
ORDER BY
    NUM_TABLES DESC;
```

### List Users

```sql
SELECT username, user_id, password, account_status, lock_date, expiry_date, profile, last_login FROM dba_users;
```

### Show your Currently Connected Username

User role assumed:

```sql
SELECT USER FROM dual;
```

User originally connected as:

```sql
SELECT CURRENT_USER FROM dual;
```

### Show Tables Owned by Currently Connected User

```sql
SELECT table_name FROM all_tables WHERE owner = USER;
```

### Show the Privileges of the Currently Connected User

```sql
SELECT * FROM user_sys_privs;
```

### Show Privileges of All Users

```sql
SELECT grantee, privilege FROM dba_sys_privs ORDER BY grantee;
```

### Show Expired Passwords

```sql
SELECT username, account_status FROM dba_users WHERE account_status LIKE '%EXPIRED%';
```

### Alter User Password

```sql
ALTER USER spacewalk IDENTIFIED BY test;
-- or prompts for a new password
-- also allows for chars like ! which aren't liked on the alter user statement
--PASSWORD
```

### Show DB Configuration Parameters

```sql
SELECT name, value FROM v$parameter;
```

### Get Table DDL

Without these doesn't give full show create table output:

```sql
SET PAGESIZE 0;
SET LONG 1000;
```

```sql
SELECT dbms_metadata.get_ddl('TABLE', 'myTable', 'mySchema') FROM DUAL;
```

### Investigate table

```sql
SELECT MIN(row_id), MAX(row_id) FROM myTable;
```

```sql
SELECT MIN(mycolumn), MAX(mycolumn), AVG(mycolumn) FROM myTable;
```

### Backup Table to adjacent backup table

Do this before any risky operations or shrinking tables:

```sql
CREATE TABLE mytable_backup AS SELECT * FROM  mytable;
```

## Space Clean Up

- drop temporary and backup tables if you can

<!-- -->

- purge recyclebin and dba recyclebin

<!-- -->

- shrink tables / tablespaces

### Purge Recyclebin

```sql
SHOW RECYCLEBIN;
```

```sql
PURGE RECYCLEBIN;
```

```sql
SHOW RECYCLEBIN;
```

To only purge the recyclebin for a given table:

```sql
PURGE TABLE table_name;
```

### Purge DBA Recyclebin

This is for all user's recyclebins.

Use
[oracle_show_dba_recyclebin.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_show_dba_recyclebin.sql)
to see the recyclebin contents for all users.

Then purge it:

```sql
PURGE DBA_RECYCLEBIN;
```

On [AWS](aws.md) RDS you will need to call this instead due to AWS restricting some system procedures:

```sql
EXEC rdsadmin.rdsadmin_util.purge_dba_recyclebin;
```

See [this doc](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.Oracle.CommonDBATasks.Database.html)
for more details.

Then re-run
[oracle_show_dba_recyclebin.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_show_dba_recyclebin.sql)
to check.

### Investigate Tablespaces Space

These scripts calculations assume an 8KB block size, verify that using this query first:

```sql
SELECT value FROM v$parameter WHERE name = 'db_block_size';
```

Should show value = `8192`.

[HariSekhon/SQL-scripts - oracle_tablespace_space.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_tablespace_space.sql)

[HariSekhon/SQL-scripts - oracle_tablespace_space2.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_tablespace_space2.sql)

### Investigate Big Tables with Free Space

[HariSekhon/SQL-scripts - oracle_table_space.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_table_space.sql)

### Shrink Table

**First [backup the table](#backup-table-to-adjacent-backup-table)** you are going to shrink to an adjacent backup table.

Then `SHRINK SPACE` of the table to reduce space allocated to it by removing unused space from its data blocks
(optimizes storage and improves performance).

`CASCADE` also shrinks dependent objects eg. indexes:

```sql
ALTER TABLE mytable SHRINK SPACE CASCADE;
```

Check the space again by running scripts in [HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts).

[Investigate table](#investigate-table) to check it looks ok.

If happy, then drop the backup table:

```sql
DROP TABLE mytable_backup;
```

Rollback if any problem following [Restore table from adjacent backup table](#restore-table-from-adjacent-backup-table).

### Shrink Tablespaces

On [AWS](aws.md) RDS follow this [doc](https://repost.aws/knowledge-center/rds-oracle-resize-tablespace).

#### Shrink Permanent Tablespace

```sql
ALTER TABLESPACE users COALESCE;
```

```sql
ALTER TABLESPACE users RESIZE 500G;
```

```text
SQL Error [3297] [42000]: ORA-03297: file contains used data beyond requested RESIZE value
```

##### Big File Tablespace

Add new temp tablespace and then remove old one:

```sql
CREATE TEMPORARY TABLESPACE
  temp2
TEMPFILE '/path/to/new_tempfile.dbf'
SIZE 50G REUSE
AUTOEXTEND ON NEXT 1G MAXSIZE 500G;
```

Switch default tempspace to the new one:

```sql
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp2;
```

Switch all users tempspaces to the new one:

```sql
BEGIN
  FOR r IN (SELECT username FROM dba_users WHERE temporary_tablespace = 'TEMP') LOOP
    EXECUTE IMMEDIATE 'ALTER USER ' || r.username || ' TEMPORARY TABLESPACE temp2';
  END LOOP;
END;
/
```

Wait for old user sessions to complete:

```sql
SELECT
  username, tablespace, blocks
FROM
  v$tempseg_usage
WHERE
  tablespace = 'TEMP';
```

Then drop the old temp tablespace:

```sql
DROP TABLESPACE TEMP INCLUDING CONTENTS AND DATAFILES;
```

##### Small File Tablespace

Create new temporary tablespace tempfile with a new size first to avoid Oracle having any period of time with no sort /
index rebuild space:

```sql
ALTER TABLESPACE temp ADD TEMPFILE '/path/to/new_tempfile.dbf' SIZE 1000M;
```

Find the path to the old tempfile:

```sql
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb FROM v$tempfile;
```

or

```sql
SELECT file_name, tablespace_name, bytes/1024/1024 AS size_mb FROM dba_temp_files;
```

Edit the filename path in this `ALTER` statement to delete that tempfile when no session is using the temp tablespace:

```sql
ALTER DATABASE TEMPFILE '/path/to/old_tempfile.dbf' DROP;
```

#### Shrink Temporary Tablespace

If this is overallocated you can drop and create it smaller.

Use this query to find out if it's a Bigfile or Smallfile tablespace. [AWS](aws.md) RDS uses Bigfile tablespaces.

```sql
SELECT TABLESPACE_NAME, CONTENTS, BIGFILE FROM DBA_TABLESPACES;
```

**WARNING**: dropping temp tablespace or tablespace file can disrupt active sessions using sorts, large queries,
or index rebuilds, all of which use the temporary tablespace and can get hit with errors like:

```text
ORA-01187: cannot read from file because it failed verification tests
```

or

```text
ORA-01110: data file name of the tempfile
```

You should add a new temp tablespace for a bigfile tablespace
or add a new temp tablespace datafile for smallfile tablespace.

Check for low activity time there are no active sessions using temp tablespace before dropping the old temporary file:

[HariSekhon/SQL-scripts - oracle_show_sessions_using_temp_tablespace.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_show_sessions_using_temp_tablespace.sql)

## Restore table from adjacent backup table

First check you have the backup table `mytable_backup`.

Once backup table contents has been verified, then empty the table to be restored:

```sql
TRUNCATE TABLE mytable;
```

Then restore the rows from the backup table:

```sql
INSERT INTO mytable SELECT * FROM mytable_backup;
```

## Troubleshooting

### Oracle Client Install `Error: Invalid version flag: or`

This happens on Amazon Linux 2 with the latest Oracle Client version 23.

**Workaround**: Install Oracle Client 21 instead.

### SQLcl Error: Could not find or load main class oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli

If you get an error running `sqlcl` or `/usr/local/sqlcl/bin/sql` like this:

```text
Error: Could not find or load main class oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli
Caused by: java.lang.ClassNotFoundException: oracle.dbtools.raptor.scriptrunner.cmdline.SqlCli
```

This rather unintuitive message is caused by the stupid installation zip having `0640` octal permissions on
`sqlcl/lib/*` so if installed as root normal users not in the `wheel` group can run the `sql` but it can't find the
`lib/*.jar` files.

**Fix**:

```shell
chmod -R o+r /usr/local/sqlcl/lib
```

If you have installed via the [DevOps-Bash-tools](devops-bash-tools.md) scripted install `install_oracle_sqlcl.sh` you
shouldn't encounter this as it fixes the permissions at install time.

<br>

**Partial dump from memory because I didn't have many notes retained from my Oracle DBA time in 2005-2009**
