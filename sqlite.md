# SQLite

<!-- INDEX_START -->

- [Summary](#summary)
- [Basic Usage](#basic-usage)
- [Config](#config)
- [Batch / Scripting](#batch--scripting)
- [Parameterized Queries](#parameterized-queries)
- [Atomic Transactions](#atomic-transactions)

<!-- INDEX_END -->

## Summary

<https://www.sqlite.org/>

SQLite is a small fast local SQL DB that stores data in a simple file usually suffixed with `.sqlite`.

It is suitable only for small databases which can reasonably fit in a single file without incurring
large I/O seek and file rewriting performance problems.

This works well for light desktop applications such as Shazam desktop,
sample applications for learning purposes,
and localized test DBs for real applications where you still want to use SQL with some representative loaded dummy data.

## Basic Usage

```shell
$ sqlite3 myfile.sqlite
sqlite>
```

Then enter SQL commands at the interactive prompt.

See batch mode further down.

To see SQLite specific commands, type:

```sqlite
.help
```

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

## Batch / Scripting

For non-interactive SQL commands on a sqlite db file, such as in scripts:

1. use the `-batch` switch for more efficient batch I/O since commits are expensive in this flat file format,
1. add the `-bail` switch to exit upon encountering any error so your script can catch any problem exit safely
   without causing a bigger problem
   1. Remember to set your shell `-e` switch, see [Bash](bash.md)

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

Code taken from `shazam_app_delete_track.sh` in [DevOps-Bash-tools](devops-bash-tools.md)
(the Shazam desktop app on macOS uses a local sqlite db):

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

BUT this fails for variables containing quotes, leaving it still vulnerable -
`.parameter` seems still too fragile for non-interactive use with arbitrary text.

Even trying to pre-load using multiple `-cmd` args failed:

```text
sqlite3 \
  -cmd ".parameter init" \
  -cmd ".parameter set :artist $artist" \
  -cmd ".parameter set :track track" \
  ...
```

After various testing with real world variety of Spotify data, everything failed except this code below -
which pre-generates SQL-safe variables using SQLite's own quoting engine
and then use those variables:

```shell
artist_sql=$(sqlite3 ':memory:' "SELECT quote($(
    printf "'%s'" "$(printf '%s' "$artist" | sed "s/'/''/g")"
));")

track_sql=$(sqlite3 ':memory:' "SELECT quote($(
    printf "'%s'" "$(printf '%s' "$track" | sed "s/'/''/g")"
));")

sqlite3 -batch -bail "$dbpath" <<EOF
    DELETE FROM ZSHTAGRESULTMO
    WHERE Z_PK IN (
        SELECT r.Z_PK
        FROM ZSHTAGRESULTMO r
        JOIN ZSHARTISTMO a ON a.ZTAGRESULT = r.Z_PK
        WHERE a.ZNAME = $artist_sql
          AND r.ZTRACKNAME = $track_sql
    );
EOF
```

It's not as pretty as I'd like, if you have a better idea, please let me know!

## Atomic Transactions

You can enforce atomicity using `BEGIN` and `COMMIT`, similar to other relational databases:

```sql
BEGIN;
INSERT ...
UPDATE ...
DELETE ...
COMMIT;
```

I/O is expensive in SQLite so batching operations is advised for performance reasons as well as logical grouping of
instructions to be atomic.
