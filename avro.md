# Avro

General purpose row oriented data format.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Avro Tools](#avro-tools)
  - [Download](#download)
  - [Run](#run)
  - [Commands](#commands)

<!-- INDEX_END -->

## Key Points

- row-based
- schema embedded json at top of file
  - better than storing in code eg. Python, R, Java
  - better than CSV/JSON which don't have type information (everything is implicitly String)
- direct mapping to/from JSON
- fast
- compact (not repeating file names like JSON)
- for small messages (streaming), should be able to exchange schema once at beginning of handshake (see docs to confirm)
- slower for read + write compared to Parquet / ORC unless scanning entire rows
- nesting, better for conversion to/from JSON/XML (parquet would end up with huge number of columns)
- splittable
- block compression
- widely available client bindings (Python, Java etc)

- schema evolution:
  - independently upgrade apps
  - ignores unexpected fields
  - default vals for missing etc
  - use enumerated values to catch producer errors
  - document all fields inside schema
  - avoid union, recursive complex types (don't map well to other tech)
  - field name conventions to help joins
  - define shared schema for common activities (eg. ErrorEvent with fields StackTrace, ApplicationName, ErrorMessage)
  - don't put system/app name in to EventName as apps are replaced with new apps over time which will end up being stuck using legacy names to avoid breaking downstream applications eg. use OrderEvent not MyAppOrderEvent
  - union { null, long } - use null to indicate optional, not stored
  - must update all reader schemas first before extending union field or readers won't know how to process
  - must provide writer's schema, doesn't have to be same as reader's schema
  - field rename requires update all reader schemas to use new name + alias old name, then update writer's schema
  - field add - new schema must have default val to fill in data
  - field removal - only if field had a default value - specify a default value for all fields (null?). This was old schema reader will use default when field isn't found

## Avro Tools

### Download

Download and install Avro Tools from [here](https://repo1.maven.org/maven2/org/apache/avro/avro-tools/).

Or using script from [DevOps-Bash-tools](devops-bash-tools.md) which automatically determines latest version if no
version is specified as the first arg:

```shell
download_avro_tools.sh  # "$version"
```

Download Avro Tools using script from [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
download_avro_tools.sh
```

### Run

Run Avro Tools jar, downloading it if not already present:

```shell
avro_tools.sh <command>
```

You can run the jar directly, it's just a longer command:

```shell
AVRO_VERSION="1.12.0"
```

```shell
java -jar "avro-tools-$AVRO_VERSION.jar" <command>
```

### Commands

```shell
hdfs dfs -cat $file | head --bytes 10K > $SAMPLE_FILE.avro
```

```shell
java -jar "avro-tools-$AVRO_VERSION.jar" getschema "$SAMPLE_FILE.avro" > "$AVRO_SCHEMA_FILE"
```

or shorter using script from [DevOps-Bash-tools](devops-bash-tools.md) repo:

```shell
avro_tools.sh getschema "$SAMPLE_FILE.avro" > "$AVRO_SCHEMA_FILE"
```

```shell
hdfs dfs -put "$AVRO_SCHEMA_FILE" "$AVRO_SCHEMA_DIR"
```

**Ported from private Knowledge Base page 2014+**
