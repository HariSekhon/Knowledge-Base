# AtlasGo

[:octocat: ariga/atlas](https://github.com/ariga/atlas)

Terraform for Database Schemas.

<!-- INDEX_START -->

- [Install](#install)
- [Inspect](#inspect)
  - [HCL](#hcl)
  - [SQL](#sql)
  - [JSON](#json)
  - [Visualize the Schema](#visualize-the-schema)
- [Apply](#apply)

<!-- INDEX_END -->

## Install

<https://atlasgo.io/getting-started>

```shell
brew install ariga/tap/atlas
```

## Inspect

<https://atlasgo.io/declarative/inspect>

### HCL

```shell
atlas schema inspect -u "mysql://$USER:$PASSWORD@$HOST:3306/$DB" > schema.hcl
```

### SQL

```shell
atlas schema inspect -u "mysql://$USER:$PASSWORD@$HOST:3306/$DB" --format '{{ sql . }}' > schema.sql
```

### JSON

To be able to use `jq` on it:

```shell
atlas schema inspect -u "$URL" --format '{{ json . }}' | jq .
```

### Visualize the Schema

By copying and pasting to:

<https://gh.atlasgo.cloud/explore>

## Apply

<https://atlasgo.io/declarative/apply>

Edit the HCL or SQL file dumped from `schema inspect`, containing the HCL or SQL `CREATE TABLE` statements.

Then apply it to the URL of a database.

`--to` - a list of URLs to apply the desired state in the file  to - can be a database URL, an HCL or SQL schema, or a migration directory:

```shell
atlas schema apply \
    -u "mysql://$USER:$PASSWORD@$HOST:3306/$DB" \
    --to file://schema.hcl
```

or

```shell
atlas schema apply \
    -u "mysql://$USER:$PASSWORD@$HOST:3306/$DB" \
    --to file://schema.sql \
    --dev-url "docker://mysql/8/$DB"  # url to a Dev database use to compute the diff
```

```shell
atlas schema inspect -u "mysql://$USER:$PASSWORD@$HOST:3306/$DB"
```

```shell
atlas migrate diff create_blog_posts \
    --dir "file://migrations" \
    --to "file://schema.hcl" \
    --dev-url "docker://mysql/8/$DB"  # url to a Dev database use to compute the diff
```

Compare 2 MySQL DBs:

```shell
atlas schema diff \
    --from "mysql://$USER:$PASSWORD@$HOST:3306/$DB1" \
    --to "mysql://$USER:$PASSWORD@$HOST:3306/$DB2"
```

The `migrations/` directory will contain an SQL file and an `atlas.sum` file for integrity checking the migrations dir hasn't changed.

```shell
atlas migrate apply \
    --url "mysql://$USER:$PASSWORD@$HOST:3306/$DB" \
    --dir file://migrations
    --dry-run
```

```shell
atlas migrate apply \
    --url "postgres://$USER:$PASSWORD@$HOST:5432/$DB?search_path=public&sslmode=disable" \
    --dir file://migrations \
    --dry-run
```

**Ported from private Knowledge Base page 2023+**
