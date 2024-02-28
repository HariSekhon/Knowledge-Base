# Solr

[Solr](https://solr.apache.org/) is the classic open-source search system. Perhaps too classic (old).

[Latest Documentation](https://solr.apache.org/guide/solr/latest/)

See [Elasticsearch](elasticsearch.md) too.

## Solr UI

Uses an embedded Jetty webapp on port 8983

[http://\<host\>:8983/solr/#/]()

## Solr CLI

If administering Solr a lot, you may find this CLI makes your day to day significantly easier and can use environment
variables to shorten your commands.

[HariSekhon/DevOps-Perl-tools](https://github.com/HariSekhon/DevOps-Perl-tools#solr)

```shell
git clone https://github.com/HariSekhon/DevOps-Perl-tools.git perl-tools
cd perl-tools
make  # installs CPAN dependencies on all major Linux and Mac systems
```
```shell
./solr_cli.--help
```


## Commercial Offerings

[LucidWorks](https://lucidworks.com/)

## Start SolrCloud Commands

On first node:

Notice the `/solr` suffix to the zkHosts to chroot the SolrCloud to the /solr path inside ZooKeeper otherwise it'll
write junk all over top level
```shell
java -DzkHosts=zk1:2181,zk2:2181,zk3:2181/solr \
  -DnumShards=2 \
  -Dbootstrap_confdir=$SOLR_HOME/example-solrcloud1/solr/collection1/conf \
  -Dcollection.configName=myconf \
  -jar start.jar
```

on subsequent nodes:

```shell
java -DzkHost=zk1:2181,zk2:2181,zk3:2181/solr -jar start.jar
```

## Solr / SolrCloud Docker Images

[HariSekhon/Dockerfiles - Solr](https://github.com/HariSekhon/Dockerfiles/tree/master/solr)

[HariSekhon/Dockerfiles - SolrCloud](https://github.com/HariSekhon/Dockerfiles/tree/master/solrcloud)

[HariSekhon/Dockerfiles - SolrCloud Dev](https://github.com/HariSekhon/Dockerfiles/tree/master/solrcloud-dev)

## SolrCloud

Clustered Solr using [ZooKeeper](https://zookeeper.apache.org/) for coordination of nodes and shards.

Expect to do shard management, recoveries and ZooKeeper contents investigation.

Strongly recommended that you use [Elasticsearch](elasticsearch.md) instead of SolrCloud.

The problem with SolrCloud is that clustering was tacked on to classic Solr as an afterthought and it shows,
compared to Elasticsearch where this was a primary consideration.

Shard management is difficult in SolrCloud and it's common to have shard outages and shard loss requiring
re-indexing from an external data store.

You will need the [Solr CLI](#solr-cli) above. There is even a `--request-core-recovery` switch that uses an API
endpoint that wasn't documented at the time of writing.

- Leader uses 100 transaction log to sync replicas
- if replicas fall too far behind leader then full replication of segments is needed instead


- CDCR - Cross DataCenter Replication
  - https://sematext.com/blog/2016/04/20/solr-6-datacenter-replication/
  - 6.0+
  - stores unlimited update log
  - 'replicator' configured on source collection sends batch updates to target collection(s)
  - shard leader receives indexing command, processes + replicates to local replicas + writes to update log for CDCR (synchronously)
  - async 'replicator' checks update log, if new creates batch + sends to target collection
  - data received by target collection leaders replicated to locally at other DC using std SolrCloud replication
  - 'replicator' batches for max scalability
  - update log only captures new indexed docs
  - indexing existing collection requires shutting down source cluster, copying source leader data dirs to target leader data dirs
  - solr.CdcrRequestHandler, insert update request processor chain in UpdateHandler (see link above for details)
  - Limitations:
    - Active - Passive
    - not bi-directional so no indexing if source cluster goes down (or perhaps but no replication back to original primary)
    - shards must be manually migrated (Elasticsearch auto-migrates shards)
  - start CDCR `http://.../<collection>/cdcr?action=START`
  - stop CDCR `http://.../<collection>/cdcr?action=STOP`
  - enable buffering `CDCR http://.../<collection>/cdcr?action=ENABLEBUFFER`
  - disable buffering `CDCR http://.../<collection>/cdcr?action=DISABLEBUFFER`


- Parallel SQL:
  - 6.0+
  - SQL Handler
  - `/solr/<collection>/select?q=<traditional_query>`
  - `/solr/<collection>/sql`
  - request body `stmt=<sql_query>`
  - request body must be urlencoded
  - Solr JDBC driver provided with SolrJ
  - GROUP BY
  - aggregates count / sum / min / max / avg
  - no JOIN

NRT DR cross site recovery down entire cluster, 1 node per shard to ZK at other DC => replicate catch up => down + reconfigure back to local ZK and start again

### Local

zkRun uses embedded zookeeper (just for testing):
```shell
java -DzkRun -DnumShards=2 -Dbootstrap_confdir=$SOLR_HOME/example-solrcloud1/solr/collection1/conf -Dcollection.configName=myconf -jar start.jar
```
```shell
java -Djetty.port=8984 -DzkHost=localhost:9983 -jar start.jar
```
Shortcut:
```shell
solr -e cloud -noprompt
```

info:
```shell
solr -i
```

```shell
solr stop -c -all
```

Routing using Murmur hash:
```
id=<shard>!<id>
```



## Hadoop MapReduce Indexer to SolrCloud

```shell
cd $SOLR_HOME
```
For dry-run to get libs locally, reuse in `-libjars` for distributed job:

```shell
export HADOOP_CLASSPATH="$HADOOP_CLASSPATH:$(ls dist/*.jar \
  contrib/map-reduce/lib/*.jar \
  dist/solrj-lib/*.jar \
  contrib/morphline-core/lib/*.jar \
  contrib/morphlines-cell/lib/*.jar \
  contrib/extraction/lib/*.jar \
  example/solr-webapp/webapp/WEB-INF/lib/*.jar |
  tr '\n' ':' |
  sed 's/:$//'
)"
```

```shell
hadoop jar dist/solr-map-reduce-*.jar org.apache.solr.hadoop.MapReduceIndexerTool --libjars ...
```

```shell
hadoop jar dist/solr-map-reduce-*.jar \
  -libjars $(sed 's/:/,/g' <<< "$HADOOP_CLASSPATH") \
  --mappers 12 \
  --morphline-file myFile.conf \
  --morphline-id morphline1 \
  --zk-host $ZOOKEEPERS \
  --collection $SOLR_COLLECTION \
  --go-love --go-live-threads 6 \
  --output-dir hdfs://nameservice1/tmp/blah \
  --verbose \
  --dry-run \
  hdfs://nameservice1/data
```

- When not on HDFS (online indexing performance sucks on HDFS),
`--output hdfs://nameservice1/` causes `org.apache.solr.common.SolrException: Directory: org.apache.lucene.store.MMapDirectory. but hdfs lock factory can only be used with HdfsDirectory`

- MRIndexer writes `tmp2/full-import-list.txt` to dir from only 1 mapper, this causes `FileNotFoundException` in
  mapper since they can't see the file when using file:/// - this rules out local index creation

- URI error was due to specifying MapReduceIndexer path as first arg, must be `hdfs:///data/...`



### MapReduce Indexer Tool

```shell
java -cp dist/*:contrib/map-reduce/lib/*:$(hadoop classpath) org.apache.solr.hadoop.MapReduceIndexerTool
```

### HDFS Find Tool

```shell
java -cp dist/*:contrib/map-reduce/lib/*:$(hadoop classpath) org.apache.solr.hadoop.HdfsFindTool --help
```

### Morphlines

of note:

- readMultiLine
- grok
- generateUUID
- convertTimestamp

## Monitoring

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins) `check_solr*` scripts.

Some more things to monitor:

- Number of queries per second
- Solr Write (`check_solr_write.pl`)
- Average response time (`check_solr_query.pl` returns QTime query response time)
- Number of updates
- Cache hit ratios
- Replication status
- Synthetic queries

## Troubleshooting

### No Leader

Shards with no filled in circle = no leader

https://solr.apache.org/guide/8_7/shard-management.html#forceleader

Forcing a leader election can lead to data loss:

```shell
curl "http://$HOST:8983/solr/admin/collections?action=FORCELEADER&collection=$COLLECTION&shard=$SHARD"
```

### Local Solr Restart

Old script `restart_local_solr.sh` example:
```shell
#!/bin/bash
set -x;
pgrep -l -f start.jar | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill;
count=0;
while ps -ef|grep start.ja[r]; do
    let count+=1;
    sleep 3;
    [ $count -ge 5 ] && break;
done;
pgrep -l -f start.jar | grep -v grep | awk '{print $2}' | xargs --no-run-if-empty kill -9;
rm -fv /data*/solr/*/index/write.lock
sleep 1;
cd /opt/solr/hdp; java -Xmx30g -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -DzkHost=$SOLR_ZOOKEEPER -jar start.jar &
exit 0
```

### Core Not Coming Up

This file in the data directory needs to exist for core to come up - only created by solr script if dir doesn't already
exists
```
touch /var/solr/data/<core>/core.properties
```

### CorruptIndexException

This is a bug - disable HDFS write cache to work around or switch back to using local disk (faster anyway)
```
org.apache.solr.common.SolrException; org.apache.lucene.index.CorruptIndexException: codec header mismatch: actual header \d+ vs expected header \d+
```


### org.apache.solr.common.SolrException: Index locked for write

After restart Solr instances, some cores don't load and you this exception.

This happens because of killing Solr instance and leaving `<dataDir>/index/write.lock` files behind which prevents
cores from loading on restart:
```
org.apache.solr.common.SolrException: Index locked for write for core Blah_shard3_replica2
```

FIX:

- stop Solr
- then run
- `rm /data*/solr/*/write.lock`
- start Solr

### Cores not coming back online after restart

Trigger recovery manually (not currently documented, but I've coded it into [solr_cli.pl](#solr-cli)):

`/solr/admin/cores?action=REQUESTRECOVERY&core=<name>`

### ClusterStatus / OverseerStatus 400 Bad Request error - unknown action

`CLUSTERSTATUS` / `OVERSEERSTATUS` returns `400 Bad Request` `"error": { "msg": "Unknown action: CLUSTERSTATUS" }`

There was a serial mismatch in logs Solr 4.10.3 vs 4.7.2 rest of cluster.

### Misc

- `dfs.replication` setting not respected SOLR-6305 and SOLR-6528
- `autoAddReplicas` add 4.10 didn't work when tested in 4.10.3
- Missing authority in path URI when using `hdfs:/tmp` => needs NN part which is the "authority" => `hdfs://nameservice1/tmp`

Partial port from private Knowledge Base 2013+
