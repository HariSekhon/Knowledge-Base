# Stress Testing

Stress testing is taking a system to its limit to see how it behaves, how it deteriorates and what the maximum functional capacity is.

Loading testing aka soak testing is sustained loading the system, rather than testing the limits.

This is useful to burn in hardware to avoid early stage production failures, leaving around 3 year later staggered failures, MTTR / MTBF etc.

<!-- INDEX_START -->
  - [Things you want to stress](#things-you-want-to-stress)
- [Apache Bench](#apache-bench)
- [Siege](#siege)
- [Hey](#hey)
- [JMeter](#jmeter)
- [BlazeMeter](#blazemeter)
- [K6 by Grafana Labs](#k6-by-grafana-labs)
- [Hadoop TestDFSIO](#hadoop-testdfsio)
- [YCSB - Yahoo Cloud Serving Benchmark](#ycsb---yahoo-cloud-serving-benchmark)
- [mvn clean package](#mvn-clean-package)
<!-- INDEX_END -->

### Things you want to stress

- CPU
- Ram
- Disk
- Network
- Concurrent Rate of Requests to Web Services

## Apache Bench

This is in the apache2-utils package.

```shell
apt-get install -y apache2-utils
```

Send 1000 requests using 10 concurrent threads representing different users at a time:

```shell
ab -n 1000 -c 10 "$URL"
```

## Siege

```shell
apt-get install -y siege
```

Send 1000 requests using 10 concurrent threads:

```shell
siege -r 1000 -c 10 "$URL"
```

## Hey

Written in Golang.

Install:

```shell
go get -u github.com/rakyll/hey
```

Send 1000 requests from 10 concurrent threads:

```shell
hey -n 1000 -c 10 "$URL"
```

https://github.com/ddosify/ddosify

## JMeter

https://jmeter.apache.org/

Mature battle tested Testing IDE written in Java.

Best known for testing Web services, but can also do databases via JDBC, FTP, LDAP,
message buses via JMS, Email services SMTP, IMAP, POP3 etc.

GUI and CLI modes. Non-trivial, you will need to RTFM.

## BlazeMeter

Managed service like JMeter.

https://www.blazemeter.com/pricing/

## K6 by Grafana Labs

https://k6.io/

[HariSekhon/Templates - k6.js](https://github.com/HariSekhon/Templates/blob/master/k6.js)

```shell
wget -nc https://raw.githubusercontent.com/HariSekhon/Templates/master/k6.js
```

```shell
k6 run k6.js
```

## Hadoop TestDFSIO

```shell
hadoop jar hadoop-test-2.0.0-mr1-cdh4.1.2.jar TestDFSIO -write -nrFiles 1000 -fileSize 600 -resFile /path/to/results.txt
```

## YCSB - Yahoo Cloud Serving Benchmark

Tests all different key-value stores performance

Install:

```shell
git clone git://github.com/brianfrankcooper/YCSB.git
cd YCSB
# mvn clean package
mvn package
```

```shell
bin/ycsb --help
```

###### Ported from private Knowledge Base page 2010+
