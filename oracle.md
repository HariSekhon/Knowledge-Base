# Oracle

<https://www.oracle.com/>

An OG of RDBMS databases with good performance, durability and PL/SQL advanced SQL.

Most of this was not retained to be ported and I don't work on Oracle any more to go back and populate this.

<!-- INDEX_START -->

- [SQL Scripts](#sql-scripts)
- [SQL Developer IDE](#sql-developer-ide)
- [Sqlplus Readline Support](#sqlplus-readline-support)
- [Alter User Password](#alter-user-password)
- [Get Table DDL](#get-table-ddl)
- [Investigate table](#investigate-table)
- [Backup Table to adjacent backup table](#backup-table-to-adjacent-backup-table)
- [Space Clean Up](#space-clean-up)
  - [Purge Recyclebin](#purge-recyclebin)
  - [Purge DBA Recyclebin](#purge-dba-recyclebin)
  - [Shrink Table](#shrink-table)
- [Restore table from adjacent backup table](#restore-table-from-adjacent-backup-table)

<!-- INDEX_END -->

## SQL Scripts

Scripts for DBA administration and performance engineering:

[HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=SQL-scripts&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/SQL-scripts)

## SQL Developer IDE

SQL Developer - free and widely used Oracle-specific IDE

Alternatives:

- Toad for Oracle
- Navicat for Oracle
- generic [SQL Clients](sql.md#sql-clients)

## Sqlplus Readline Support

Use readline wrapper in front of `sqlplus` to get command history:

```shell
rlwrap sqlplus user/pass@database
```

`rlwrap` does segfault so you may want to stop using it in certain cases, like with logon prompts or when using password
below.

## Alter User Password

```sql
ALTER USER spacewalk IDENTIFIED BY test;
-- or prompts for a new password
-- also allows for chars like ! which aren't liked on the alter user statement
--PASSWORD
```

## Get Table DDL

Without these doesn't give full show create table output:

```sql
SET PAGESIZE 0;
SET LONG 1000;
```

```sql
SELECT dbms_metadata.get_ddl('TABLE', 'myTable', 'mySchema') FROM DUAL;
```

## Investigate table

```sql
SELECT MIN(row_id), MAX(row_id) FROM myTable;
```

## Backup Table to adjacent backup table

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
PURGE DBA_RECYCLEBIN;
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

Then re-run
[oracle_show_dba_recyclebin.sql](https://github.com/HariSekhon/SQL-scripts/blob/master/oracle_show_dba_recyclebin.sql)
to check.

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

If not happy, then [Restore table from adjacent backup table](#restore-table-from-adjacent-backup-table).

## Restore table from adjacent backup table

First check you have the backup table `mytable_backup`...
then empty the table to be restored:

```sql
TRUNCATE TABLE mytable;
```

Then restore the rows from the backup table:

```sql
INSERT INTO mytable SELECT * FROM mytable_backup;
```

**Mostly unretained 2005-2009**
