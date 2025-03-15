# Kafka

TODO: port Kafka notes here

<!-- INDEX_START -->

- [Nagios-Plugin-Kafka with Kerberos support](#nagios-plugin-kafka-with-kerberos-support)
- [Nagios Plugins for Kafka API written in Python & Perl](#nagios-plugins-for-kafka-api-written-in-python--perl)
- [Kafka on Kubernetes](#kafka-on-kubernetes)
- [Diagrams](#diagrams)
  - [Kafka Pub/Sub](#kafka-pubsub)
  - [Kafka Flink Elasticsearch](#kafka-flink-elasticsearch)
  - [Kafka 101](#kafka-101)

<!-- INDEX_END -->

## Key Points

- A Kafka topic is divided into partitions
  - each partition can then be split across different brokers (servers) for horizontal scaling
- Messages inside a partition are sequentially ordered
- Partitions enable parallelism for a topic
- Consumer Group - multiple clients that subscribe using the same consumer group will split reading the messages of that
  topic between them
  - Messages from a partition go to only one client in a given consumer group
  - More partitions than consumers will result in some consumers reading messages from multiple partitions

## Nagios-Plugin-Kafka with Kerberos support

[HariSekhon/Nagios-Plugin-Kafka](https://github.com/HariSekhon/Nagios-Plugin-Kafka)

API monitoring plugin does full pub-sub unique message with Kerberos support. Written in [Scala](scala.md).

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Nagios-Plugin-Kafka&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Nagios-Plugin-Kafka)

## Nagios Plugins for Kafka API written in Python & Perl

[HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Nagios-Plugins&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Nagios-Plugins)

## Kafka on Kubernetes

<https://strimzi.io/>

## Diagrams

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### Kafka Pub/Sub

![Kafka Pub/Sub](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/refs/heads/master/images/kafka_pubsub.svg)

### Kafka Flink Elasticsearch

![Kafka Flink Elasticsearch](https://github.com/HariSekhon/Diagrams-as-Code/raw/master/images/kafka_flink_elasticsearch.svg)

### Kafka 101

![Kafka 101](images/kafka_101.gif)
