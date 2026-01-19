# SQLite

<!-- INDEX_START -->

- [Summary](#summary)
- [Config](#config)
- [Batch](#batch)
- [Parameterized Queries](#parameterized-queries)
- [Atomic Transactions](#atomic-transactions)

<!-- INDEX_END -->

## Summary

<https://www.sqlite.org/>

SQLite is a small fast local SQL DB that stores data in a simple file usually suffixed with `.sqlite`.

## Config

SQLite configuration is stored in:

```text
.sqliterc
```

My [.sqliterc](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/configs/.sqliterc)
config is available in the [DevOps-Bash-tools](devops-bash-tools.md) repo:

```text
.headers on
.mode column
.nullvalue NULL
-- .prompt "> "
.timer on
```

## Batch

For non-interactive SQL commands on a sqlite db file,
use the `-batch` switch and the `-bail` switch to exit on any error:

```shell
sqlite3 -batch -bail /path/to/file.sqlite <<EOF
...
...
...
EOF
```

## Parameterized Queries

Use parameterized queries as database best practice to avoid
[SQL Injection](https://en.wikipedia.org/wiki/SQL_injection) attacks.

This is how you do it in SQLite - this code is taken from `shazam_app_delete_track.sh` in
[DevOps-Bash-tools](devops-bash-tools.md) (the Shazam desktop app on macOS uses a local sqlite db):

```shell
$ sqlite3 -batch -bail "$dbpath" <<EOF

.parameter init
.parameter set :artist "$artist"
.parameter set :track "$track"

DELETE FROM ZSHTAGRESULTMO
WHERE Z_PK IN (
  SELECT r.Z_PK
  FROM ZSHTAGRESULTMO r
  JOIN ZSHARTISTMO a ON a.ZTAGRESULT = r.Z_PK
  WHERE a.ZNAME = :artist
  AND r.ZTRACKNAME = :track
);
EOF
```

## Atomic Transactions

You can enforce atomicity using `BEGIN` and `COMMIT`, similar to other relational databases:

```sql
BEGIN;
INSERT ...
UPDATE ...
DELETE ...
COMMIT;
```
