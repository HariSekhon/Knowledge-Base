# Greenplum

EMC spin off Pivotal for Greenplum + GemFire (in-memory caching system)

<!-- INDEX_START -->
- [Summary](#summary)
- [Customers](#customers)
<!-- INDEX_END -->

## Key Points

- now Apache open sourced - but some text analytics and lucene search add-ons still proprietary
- licensed per CPU core
- MPP db based off PostgreSQL
- 1.5M lines of C / C++
- 180k lines of Python
- 60k lines of Java
- Segment (worker node) is a modified PostgreSQL that spins up executors for each query
- ORCA - Cost Based Optimizer

<http://www.ness-ses.com/big-data-101-the-rise-and-fall-of-greenplum-2/>

- several high profile customers, BUT
- difficult to tune
- wanted all available system resources
- instability with concurrent queries
- tried queues, but not dynamic enough for real usage, acquired NoreVRP for dynamic database config but was hard to configure
- Barclays discovered Greenplum actually slowed down with disk cache as it expected to do full table disk scans for each query
- other customers discovered under high write load it caused Linux journalling errors that required rebuilding the DB (a 2 day process)
- competition from Hadoop, Hive, Impala
- Pivotal tried creating Hawq (Greenplum on HDFS) to counter, but proprietary format rendered use of HDFS pointless
- March 2015 open sourced Greenplum amid flood of open source RFPs
- development likely to stagnate as open source community fails to pick it up
- legacy technology

## Customers

- NTT Decomo (Telco) - biggest cluster (nearly 7PB)
- DTCC - Depository Trust & Clearing Corportation
- 2nd largest cluster, biggest in continental Europe
- 1 cluster in US East, 1 cluster Netherlands
- Skype (kept Greenplum after M$ aquisition)
- MBNL
- Telcos in Middle East, Africa
- Retailers & Telco
- Financial in US
- Telcos in Asia
- Ali Baba - Greenplum open source non-commercial, packaging it themselves (9PB)

###### Ported from various private Knowledge Base pages 2016+
