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
