# Kylin

OLAP Cube engine from eBay (Apache incubator), combines HBase for low latency and Hive for mid latency

<!-- INDEX_START -->

- [Key Points](#key-points)
- [MOLAP - Multi-dimensional OLAP](#molap---multi-dimensional-olap)
- [ROLAP - Relational-OLAP](#rolap---relational-olap)
- [How Kylin mixes MOLAP and ROLAP](#how-kylin-mixes-molap-and-rolap)

<!-- INDEX_END -->

## Key Points

- Fast OLAP Cube on HBase + Hive
- uses HBase Coprocessors
- ANSI SQL
- web UI for managing cubes
- ACLs
- Tableau/Microstrategy integration
- LDAP support
- Kylin Framework - Metadata Engine
  Query Engine
  Job Engine
  Storage Engine
  REST Server (client requests)
- Extensions - plugins
- ODBC + JDBC drivers
- Ambari + Hue plugins
- Integration - Lifecycle Management Support integrates with Job Scheduler, ETL, Monitoring Systems

## MOLAP - Multi-dimensional OLAP

Pre-computes data along different dimensions of interest and store resultant values in the cube.

MOLAP is much faster but is inflexible.

## ROLAP - Relational-OLAP

Uses star or snow-flake schema to do runtime aggregation.

ROLAP is flexible but much slower.

## How Kylin mixes MOLAP and ROLAP

Kylin pre-builds MOLAP in HBase.

If query can be satisfied with it, then it uses HBase.

Otherwise it uses Hive (ROLAP slow).

**Ported from private Knowledge Base pages 2014+**
