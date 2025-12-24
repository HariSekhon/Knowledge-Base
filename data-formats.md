# Data Formats

<!-- INDEX_START -->

- [Avro](#avro)
- [Parquet](#parquet)
- [Arrow](#arrow)
- [ORC](#orc)
- [CSV](#csv)
- [JSON](#json)
- [BSON](#bson)
- [CSON](#cson)
- [TOML](#toml)
- [XML](#xml)
  - [XML Lint](#xml-lint)
  - [XML Starlet](#xml-starlet)
- [YAML](#yaml)
- [HBase vs Parquet vs Avro](#hbase-vs-parquet-vs-avro)

<!-- INDEX_END -->

## Avro

See the [Avro](avro.md) doc page.

## Parquet

See the [Parquet](parquet.md) doc page.

## Arrow

- in-memory data format
- columnar
- vectorized operations - SIMD (Single Input Multiple Data)
- zero-copy reads, no serialization
- language support:
  - [Java](java.md)
  - C / C++
  - [Python](python.md)
  - [Ruby](ruby.md)
  - Javascript
  - [Golang](golang.md) (contributed by InfluxDB)
- de-facto in-memory analytics format, supported by:
  - Calcite
  - [Cassandra](cassandra.md)
  - [Apache Drill](drill.md)
  - [Hadoop](hadoop.md)
  - [HBase](hbase.md)
  - Ibis
  - [Impala](impala.md)
  - Kudu
  - Pandas
  - [Parquet](parquet.md)
  - Phoenix
  - [Spark](spark.md)
  - [Storm](storm.md)

## ORC

- columnar
- optimized for reads, write overhead
- lightweight indexing or skipping blocks of rows
- basic stats embedded (min, max, sum, count)
- no schema evolution yet

```text
-d   dumps data rather than metadata Hive 0.15 / 1.1 onwards
--rowindex <cols>
-t  timezone of the writer  Hive 1.2 onwards
-j  prints metadata as json Hive 1.3 onwards
-p  pretty print json
```

```shell
hive --orcfiledump [-j] [-p] [-d] [-t] [--rowindex <col_ids>] <location-of-orc-file>
```

## CSV

<https://pythonhosted.org/chkcsv/>

[csvkit](https://csvkit.readthedocs.io/en/latest/) - CLI tools for working with CSV files

[csvgroup](https://csvkit-cypreess.readthedocs.io/en/latest/scripts/csvgroup.html) - SQL-like selects against CSV files

[json2csv](https://juanjodiaz.github.io/json2csv/#/) - CLI to convert from JSON to CSV:

```shell
json2csv
```

## JSON

See [JSON](json.md) doc page.

## BSON

Binary JSON

## CSON

CoffeeScript Object Notation

Cursive Script Object Notation - used by Atom editor config files

schema-compressed JSON - can omit some syntax which is inferred

- strict superset of JSON
- allows # line comments
- trailing commas or missing commas between elements if separated by newlines

looks like there is a default cson module in Python 2.7

[:octocat: gt3389b/python-cson](https://github.com/gt3389b/python-cson)

```shell
pip install python-cson
```

```shell
python-cson $pytools/tests/data/test.json -f /dev/stdout
```

## TOML

Tom's Obvious Minimal Language

Similar to ini format.

Has "table expansion" (nesting):

```toml
[a.b.c]
d = 'Hello'
e = 'World'
```

## XML

### XML Lint

Available from packages:

- `libxml` ([RPM](redhat.md))
- `libxml2-utils` ( [Deb](debian.md) / [Apk](alpine.md) )
- automatically available on [Mac](mac.md)

```shell
xmllint --format "$file.xml"
```

Or pipe XML in via standard input to validate and and use `--format` to pretty print it:

```shell
xmllint --format - < "$file.xml"
```

### XML Starlet

An excellent program that can format, validate and select data from XML,
and even escape / unescape special XML characters like `&amp;` vs `&`.

```shell
xmlstarlet --help
```

## YAML

See [YAML](yaml.org) doc.

## HBase vs Parquet vs Avro

- HBase - mutable data, but not scans eg `count(*)`
- Avro (row-based) - full scans all fields
- Parquet (columnar) - restricting queries to subset of columns

**Ported from private Knowledge Base page 2014+**
