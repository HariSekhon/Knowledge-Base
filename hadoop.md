# Hadoop

NOT PORTED YET

<!-- INDEX_START -->

- [Healthchecks](#healthchecks)
- [MapR Cluster](#mapr-cluster)

<!-- INDEX_END -->

## Healthchecks

Authenticate with Kerberos first (if you're not using Kerberos, you really should be otherwise your cluster has zero security).

```shell
kinit
```

## MapR Cluster

This sub-section is for MapR managed Hadoop clusters only.

Centrify does `default_ccache_name=KCM:...` so you will need to `export KRB5CCNAME` but this messes up some hadoop commands
so only prefix it to lines like 'maprlogin kerberos' and 'sqlline'

Authenticate mapr using the kerberos ticket from `kinit` above.

```shell
maprlogin kerberos
```

running services:

```shell
maprcli node list -columns hostname,svc
```

```shell
maprcli node cldbmaster
```

configured services:

```shell
maprcli node list -columns hostname,csvc
```

```shell
maprcli alarm list
```

### HDFS

```shell
hadoop fs -ls /
```

### Yarn

```shell
yarn node -list | tee /dev/stderr | grep -c RUNNING
```

### MapReduce

Run a calculate Pi MapReduce job across the cluster nodes:

```shell
hadoop jar /opt/mapr/hadoop/hadoop-*/share/hadoop/mapreduce/hadoop-mapreduce-excamples-*-mapr-*.jar pi 10 100
```

#### Spark

Run a calculate Pi Spark job across the cluster nodes:

```shell
/opt/mapr/spark/spark-*/bin/spark-submit --master yarn --class org.apache.spark.examples.SparkPi /opt/mapr/spark/spark-*/examples/jars/spark-examples_*-mapr-*.jar 10 100
```

### Drill

Avoid errors for user accounts writing to query log:

```shell
cd /opt/mapr/drill/drill-*/logs/ && touch sqlline{,_queries}.log
chmod -v 0666 /opt/mapr/drill/drill-*/logs/sqlline{,_queries}.log
avoid flexjson classpath error:
ln -sv /opt/mapr/lib/flexjson-*.jar /opt/mapr/drill/drill-*/jars/
```

Should configure Drill with `mapr/<cluster_name>@$REALM` instead so that ZooKeeper can connect to any of them:

Any spaces in the connection string will results in an `IllegalArgumentException`

```shell
sqlline -u "jdbc:drill:drillbit=$(hostname -f);auth=kerberos;principal=mapr/$(hostname -f)@$REALM" <<< "SELECT * FROM sys.drillbits;"
```

### Oozie

```shell
/opt/mapr/oozie/oozie-*/bin/oozie admin -oozie http://$(hostname -f):11000/oozie -status
```

MapR-DB:

```shell
mapr dbshell <<< "list"
```

**Ported from private Knowledge Base pages 2010+**
