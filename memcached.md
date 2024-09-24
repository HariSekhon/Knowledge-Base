# Memcached

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Monitoring](#monitoring)
- [Diagrams](#diagrams)
  - [Memcached in AWS Clustered Web Services](#memcached-in-aws-clustered-web-services)
  - [Memcached in Multi-Datacenter Java Stack](#memcached-in-multi-datacenter-java-stack)

<!-- INDEX_END -->

## Key Points

- simple key=value pairs in memory
- used as a cache to speed up web applications or other apps that put/get values to it
- put / get by key
- port 11211
- standalone individual daemon, non-clustered first generation NoSQL tech
- usually used on each web / app server to be used locally on that server only
- often to offload cache queries from things like [RDBMS](sql.md)
- no authentication - restrict socket to listen on localhost loopback address for local server access only

<!-- -->

- Memcached => Membase => Couchbase (2.0 Jan 2012)

See also [Couchbase](couchbase.md) doc.

## Monitoring

- `check_memcached_key.pl` - checks a specific key exists and optionally content matches against a given regex and/or number range thresholds
- `check_memcached_stats.pl` - checks the stats of a memcached instance
- `check_memcached_write.pl` - full API level unique write + read back check

See [Couchbase Monitoring](couchbase.md#monitoring) section too.

## Diagrams

From [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### Memcached in AWS Clustered Web Services

![Memcached in AWS Clustered Web Services](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/aws_clustered_web_services.png)

### Memcached in Multi-Datacenter Java Stack

![Memcached in Multi-Datacenter Java Stack](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/multi_dc_gslb_f5_java_stack.png)

**Partial port from private Knowledge Base page 2013+**
