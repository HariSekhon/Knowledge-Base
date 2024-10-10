# SQL

<!-- INDEX_START -->

- [SQL Scripts](#sql-scripts)
- [SQL Clients](#sql-clients)
- [SQL Linting](#sql-linting)
  - [SQLFluff](#sqlfluff)
  - [SQLLint (SQL-Lint)](#sqllint-sql-lint)
  - [SQLCheck](#sqlcheck)
  - [SQLint](#sqlint)
  - [Popeye](#popeye)
  - [SonarQube with SQL Plugin](#sonarqube-with-sql-plugin)
  - [ALE (Asynchronous Lint Engine)](#ale-asynchronous-lint-engine)
  - [SQLcodegen](#sqlcodegen)
- [ACID](#acid)
- [SQL Query Logical Order](#sql-query-logical-order)
- [Meme](#meme)
  - [Update One Record](#update-one-record)

<!-- INDEX_END -->

## SQL Scripts

Scripts for [PostgreSQL](postgres.md), [MySQL](mysql.md), AWS Athena and Google BigQuery:

[HariSekhon/SQL-scripts](https://github.com/HariSekhon/SQL-scripts)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=SQL-scripts&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/SQL-scripts)

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

## SQL Linting

### SQLFluff

<https://sqlfluff.com>

Extensible and customizable SQL linter with support for multiple dialects, allowing for strict style enforcement.

### SQLLint (SQL-Lint)

<https://sql-lint.github.io>

Simple, fast, and open-source SQL linter that checks for common issues in SQL queries.

### SQLCheck

<https://github.com/jarulraj/sqlcheck>

Focuses on detecting anti-patterns in SQL queries to optimize performance and maintainability.

### SQLint

<https://github.com/purcell/sqlint>

Minimalist linter for SQL code, primarily for catching syntax errors in your queries.

### Popeye

<https://github.com/derailed/popeye>

A Kubernetes reporting tool that also helps analyze and lint database configurations.

### SonarQube with SQL Plugin

<https://www.sonarqube.org>

SonarQube supports SQL linting through its plugin system, helping enforce best practices and maintainability.

### ALE (Asynchronous Lint Engine)

<https://github.com/dense-analysis/ale>

A linter for many languages, including SQL, integrated into [Vim/Neovim](vim.md) for real-time feedback.

### SQLcodegen

<https://sqlcodegen.com>

A database schema documentation tool that can automatically lint and analyze SQL queries.

**TODO**

- [SQLMesh](https://sqlmesh.com/)

## ACID

Atomic, Consistent, Isolated & Durable.

ACID compliance is a standard feature of RDBMS SQL databases.

![ACID](images/acid.gif)

<!-- error accessing this now, try to find original and import it instead
## SQL Joins

![](https://media.licdn.com/dms/image/D5622AQGSP8OYFxOSaA/feedshare-shrink_2048_1536/0/1718097295510?e=1721865600&v=beta&t=Z2JCgUx04L5isIdQ1b7xb9_jywoUAKPn5G6Uwhbzg1E)
-->

## SQL Query Logical Order

![SQL Query Logical Order](images/sql_query_logical_order.gif)

## Meme

### Update One Record

Be careful and remember to `SELECT` with `WHERE` clause before editing it to an `UPDATE`!

![Meme Update One Record](images/sql_update_command_fix_one_record.jpeg)
