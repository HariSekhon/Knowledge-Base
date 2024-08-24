# Java JVM Performance Tuning

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Read up on JVM Garbage Collection Basics First](#read-up-on-jvm-garbage-collection-basics-first)
- [Don't make the Java Heaps too big](#dont-make-the-java-heaps-too-big)
- [Set `-Xmx` and `-Xms` to the same value](#set--xmx-and--xms-to-the-same-value)
- [JVM RAM overhead space](#jvm-ram-overhead-space)
- [Garbage Collection algorithm](#garbage-collection-algorithm)
- [G1GC pause time goal is a hint only](#g1gc-pause-time-goal-is-a-hint-only)
- [Add Verbose GC logging so you can investigate and debug GC Pauses](#add-verbose-gc-logging-so-you-can-investigate-and-debug-gc-pauses)
- [OutOfMemory restart](#outofmemory-restart)
- [HBase Diagram Example of an application that needs such tuning](#hbase-diagram-example-of-an-application-that-needs-such-tuning)

<!-- INDEX_END -->

## Key Points

This is important for low latency Java applications and clustered technologies using ZooKeeper.

Garbage Collection pauses can kill clusters due to losing ZooKeeper leader elections caused by temporary GC pauses
causing application hands to not respond to ZooKeeper in time to keep hold of ephemeral znodes.

Such high performance clusters are susceptible to cluster instability and intermittent outages as a result of getting this wrong.

For high-throughout non-interactive batch systems with no ZooKeeper coordination this doesn't matter as much and you
could optimize for throughput instead of GC pause times.

## Read up on JVM Garbage Collection Basics First

<https://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html>

## Don't make the Java Heaps too big

Bigger heap sizes mean long stop-the-world GC pauses.

Even G1GC isn't magic and that target millis is only a guide.

If you abuse the JVM heap size it won't be able to stick to that 100ms target you've given it.

There is no right answer to heap size as it depends on the application but aim for 16GB and spread horizontally.

Especially if you're got NoSQL horizontally scalable distributed computing software like HBase or SolrCloud.

## Set `-Xmx` and `-Xms` to the same value

The -Xmx is the max heap.

The -Xms is the min heap.

By setting the minimum heap -Xms to the same as the max heap it pre-allocates all the ram to the JVM at startup.

This makes it less likely that the JVM would swap or get an OOM out of memory error crash later.
Swap should be disabled on any modern server anyway. RAM is cheap. Engineer time is expensive.

```shell
-Xms16G -Xmx16G
```

## JVM RAM overhead space

Allocate 20% more than the JVM heap size to account for off-heap memory usage and other JVM overheads.

This means for `-Xmx16G` 16GB of RAM allocated to the JVM, expect the Java process to take 20GB of server RAM.

## Garbage Collection algorithm

If in doubt, use G1GC. This is the best for reducing GC pauses.

`-XX:+UseG1GC`

## G1GC pause time goal is a hint only

Internally it tweaks other knobs, but will miss its pause targets if you run large heap sizes with heavily used applications.

## Add Verbose GC logging so you can investigate and debug GC Pauses

```shell
-XX:+UseGCLogFileRotation
-XX:NumberOfGCLogFiles=10
-XX:GCLogFileSize=50M
-Xloggc:/var/log/myapp/gc.log
```

## OutOfMemory restart

```shell
-XX:OnOutOfMemoryError="systemctl restart myapp.service"
```

## HBase Diagram Example of an application that needs such tuning

[Diagrams-as-Code - OpenTSDB on HBase](https://github.com/HariSekhon/Diagrams-as-Code#opentsdb-on-kubernetes-and-hbase)

![](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/opentsdb_kubernetes_hbase.svg)

**Partial port from private Knowledge Base page 2011+**
