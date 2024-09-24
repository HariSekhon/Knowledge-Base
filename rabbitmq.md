# RabbitMQ

Popular Pub/Sub message queue with clustering.

Written in Erlang, invented by Pivotal.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Ports](#ports)
- [Exchanges](#exchanges)
  - [Fanout](#fanout)
  - [Direct](#direct)
  - [Topic](#topic)
  - [Binding Exchanges](#binding-exchanges)
- [Commands](#commands)
- [Management](#management)
  - [Web UI](#web-ui)
  - [REST API](#rest-api)
    - [Create Management UI Users](#create-management-ui-users)
    - [Enable Management UI](#enable-management-ui)
  - [RabbitMQ Admin Command](#rabbitmq-admin-command)
- [Monitoring](#monitoring)
  - [Management UI](#management-ui)
  - [Nagios Plugins](#nagios-plugins)
- [Python API](#python-api)
  - [Pub-Sub Fanout](#pub-sub-fanout)
  - [Temporary Queue](#temporary-queue)
  - [Pub-Sub](#pub-sub)
  - [Direct Exchange](#direct-exchange)
  - [Consumer](#consumer)
  - [Producer](#producer)
- [Diagram](#diagram)
  - [RabbitMQ Pub/Sub](#rabbitmq-pubsub)

<!-- INDEX_END -->

## Key Points

- Clustering - all nodes can be queried for all queues
  - each queue lives on a single master node + mirrors
  - oldest mirror is promoted on master failure
  - single master guarantees FIFO ordering in queue
  - exchanges + bindings exist on all nodes
  - cluster formation:
    - static:
    - config file
    - rabbitmqctl commands
  - dynamic:
    - DNS
    - via plugins:
      - AWS EC2
      - Kubernetes
      - Consul
      - Etcd
- HA - replication - mirrored queues - requires nodes to be in a cluster
- Scaling:
  - [Sharding](https://github.com/rabbitmq/rabbitmq-sharding)
    - built on hashing exchange (built-in plugin)
  - plugins:
    - `rabbitmq-autocluster`
    - `rabbitmq-clusterer`
- Performance limitation - buffering in RAM backlogs `vm_memory_high_watermark`
- resync takes ages
- AMQP 0.9 (ActiveMQ implements AMQP 1.0)
- [Kafka](kafka.md) has much better performance and durability

## Ports

| Port  | Description                             |
|-------|-----------------------------------------|
| 5672  | RabbitMQ AMQP                           |
| 15672 | Management Plugin UI / Rest API (3.0+)  |
| 55672 | Management Plugin UI / Rest API (2.x)   |

## Exchanges

### Fanout

Dumb broadcast to all queues, ignores `routing_key`.

### Direct

Sends to queues with `routing_key` binding using exact match to message `routing_key` as sent by publisher.

- multiple bindings for same queue, each with different `routing_key`
- allows same queue to collect selection of messages from exchange
- multiple queues bound to same `routing_key`
- delivers same message to all queues bound with that `routing_key`
- **WARNING: messages with a `routing_key` with no queues bound for that `routing_key` will be discarded!**

### Topic

Flexible complex routing, sends to queues with matching `routing_key` bindings.

- matching logic:
  - `*` represents 1 word
  - `#` represents zero or more words
- `routing_key` - words separated by dots, 255 bytes

**Always use Topic exchange - it's the most flexible**

- can do Danout tyle with just `#` routing_keys
- can do Direct simple behaviour
- can do multi-part matches

### Binding Exchanges

Bind exchanges to other exchanges with routing keys just like queues!

See [Pika RabbitMQ Python](python.md#pubsub) API:

<https://pika.readthedocs.io/en/0.10.0/modules/adapters/blocking.html#pika.adapters.blocking_connection.BlockingChannel.exchange_bind>

## Commands

```shell
rabbitmqctl status
```

```shell
rabbitmqctl cluster_status
```

```shell
rabbitmqctl list_exchanges
```

```shell
rabbitmqctl list_queues
```

```shell
rabbitmqctl list_bindings
```

Check for unacknowledged messages (catches client that forgets to send ack in consumer callback function):

```shell
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

<!--
XXX: Ng pl this figure
-->

## Management

### Web UI

<http://www.rabbitmq.com/management-cli.html>

### REST API

Enable web UI / REST API - port 55672 or 15672 (3.0+)

`guest` / `guest` username password combination only works on localhost

#### Create Management UI Users

`RABBITMQ_DEFAULT_USER` / `RABBITMQ_DEFAULT_PASS` environment variables are supported by official RabbitMQ images and
probably available in environment:

```shell
RABBITMQ_USER="${RABBITMQ_USER:-${RABBITMQ_DEFAULT_USER:-rabbituser}}"
RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-${RABBITMQ_DEFAULT_PASS:-rabbitpw}}"
```

```shell
rabbitmqctl add_user "$RABBITMQ_USER" "$RABBITMQ_PASSWORD"
```

```shell
rabbitmqctl set_user_tags "$RABBITMQ_USER" administrator
```

#### Enable Management UI

```shell
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management
```

```shell
service rabbitmq restart
```

or on newer Linux systems:

```shell
systemctl restart rabbitmq
```

### RabbitMQ Admin Command

Python CLI to the HTTP Rest Managment API:

```shell
rabbitmqadmin --help
```

requires Management plugin to be enabled above

Download `rabbitmqadmin` from <http://$HOST:15672/cli/>

Bash Completion:

```shell
sudo sh -c 'rabbitmqadmin --bash-completion > /etc/bash_completion.d/rabbitmqadmin'
```

```shell
rabbitmqadmin -H "$HOST" -u "rabbituser" -p "rabbitpw" list vhosts
```

with specific cols:

```shell
rabbitmqadmin list queues vhost name node messages message_stats.publish_details.rate
```

One per line:

```shell
rabbitmqadmin -f long -d 3 list queues
```

Declare exchange:

```shell
rabbitmqadmin declare exchange name=my-new-exchange type=fanout
```

Declare queue:

```shell
rabbitmqadmin declare queue name=my-new-queue durable=false
```

Publish test message:

```shell
rabbitmqadmin publish exchange=amq.default routing_key="test" payload="hello, world"
```

Get test message:

```shell
rabbitmqadmin get queue="test" requeue=false
```

Close all connections:

```shell
rabbitmqadmin -f tsv -q list connections name |
while read conn; do
    rabbitmqadmin -q close connection name="${conn}"
done
```

```shell
rabbitmqadmin export rabbit.config
```

```shell
rabbitmqadmin import rabbit.config
```

## Monitoring

### Management UI

Use the [Management UI](#management-ui) enabled above for interactive monitoring.

### Nagios Plugins

See [HariSekhon/Nagios Plugins](https://github.com/HariSekhon/Nagios-Plugins) for a selection of [Nagios](nagios.md)
plugins for RabbitMQ.

## Python API

Official AMQP client:

```python
import pika

credentials = pika.PlainCredentials(user, password)

parameters = pika.ConnectionParameters('192.168.99.100', credentials=credentials)

connection = pika.BlockingConnection(parameters)

channel = connection.channel()
```

### Pub-Sub Fanout

```python
channel.exchange_declare(exchange='logs', type='fanout')
```

### Temporary Queue

Generate a random queue name just for our process by omitting the name, set exclusive so it's deleted after disconnect.

Needed to add subscriber to Fanout pub-sub or Direct Exchange.

```python
result = channel.queue_declare(exclusive=True)

queue_name = result.method.queue # amq.gen-XXXX....
```

### Pub-Sub

Bind personal queue to fanout exchange `logs` to get all the messages from it:

```python
channel.queue_bind(exchange='logs', queue = result.method.queue)
```

### Direct Exchange

```python
channel.exchange_declare(exchange='direct_logs', type='direct')
channel.queue_bind(exchange='myExchange', queue='myQueue', routing_key='blah')
```

### Consumer

Idempotent queue creation (re-runnable, as long as queue params aren't different)

Must define queue in client before using in case producer hasn't run to create queue yet

**WARNING: Queues are non-durable by default and disappear on restart!**

```python
result = channel.queue_declare(queue='test', durable=True)
assert result.method.queue == 'test'
```

```python
def my_callback(ch, method, properties, body):
    # do stuff
    channel.basic_ack(delivery_msg = method.delivery_msg)
```

Don't give more than one message to consumer in case some get more heavy messages
and others get light messages, this way the next free worker gets the next message.

```python
channel.basic_qos(prefetch_count=1)
```

Configure consumer to call `my_callback` function for each message
requires ack by default:

```python
channel.basic_consume(my_callback, queue='test') #, no_ack=True)
```

Start consuming to loop reading messages from queue indefinitely, calls `my_callback` method for each message
requires ack by default:

```python
channel.start_consuming()
```

This is only the number of messages that consumer can fetch in BlockChannel without blocking, not check worthy -
not sure why this is really here:

```python
channel.get_waiting_message_count()
```

### Producer

**WARNING: Sending msg to non-existent queue will just trash the message!**

**WARNING: Queues are non-durable by default and disappear on restart!**

```python
channel.queue_declare(queue='test', durable=True)
```

Nameless exchange sends msg to queue with same name as routing_key:

```python
channel.basic_publish(exchange='',
  routing_key='test',
  body='test message',
  properties=pika.BasicProperties(
    delivery_mode = 2 # persistent
  )
)
# flush
# TODO: is there a way to flush without closing connection?
connection.close()
```

## Diagram

From the [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) repo:

### RabbitMQ Pub/Sub

![RabbitMQ Pub/Sub](https://raw.githubusercontent.com/HariSekhon/Diagrams-as-Code/refs/heads/master/images/pubsub_rabbitmq.svg)

**Ported from private Knowledge Base pages 2013+**
