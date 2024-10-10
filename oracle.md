# Oracle

Most of this was not retained to be ported and I don't work on Oracle any more to go back and populate this.

<!-- INDEX_START -->

- [SQL Scripts](#sql-scripts)
- [SQL Developer IDE](#sql-developer-ide)
- [Sqlplus Readline Support](#sqlplus-readline-support)
- [Alter User Password](#alter-user-password)
- [Get Table DDL](#get-table-ddl)
- [Investigate table](#investigate-table)

<!-- INDEX_END -->

## SQL Scripts

See [HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts) repo for some Oracle scripts.

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

**Mostly unretained 2005-2009**
