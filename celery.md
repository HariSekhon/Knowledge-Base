# Celery

<https://docs.celeryq.dev/en/stable/index.html>

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Install](#install)
- [Celery App](#celery-app)

<!-- INDEX_END -->

## Key Points

Distributed Task Queue

- Brokers + Workers
  - Celery workers monitor message for tasks
  - Celery workers can process millions of tasks a minute, with sub-millisecond round-trip latency (using RabbitMQ, librabbitmq and optimized settings)
- Brokers are Message Queues between workers:
  - RabbitMQ (default, feature complete, with monitoring + remote control)
  - Redis    (also feature complete as above)
  - Amazon SQS
  - ZooKeeper (experimental - this is not a good idea, will not perform well)
  - Consul (experimental)
- HA (via Brokers)
- result stores:
  - AMQP (RabbitMQ)
  - Redis
  - Memcached
  - SQLAlchemy
  - Django ORM
  - Cassandra
  - Elasticsearch
  - Couchbase
  - Riak
  - DynamoDB
  - Consul

## Install

```shell
pip install -U Celery
```

Install modules like so, see docs for all the modules for the above brokers and result stores:

```shell
pip install "celery[librabbitmq,redis,auth,msgpack]"
```

Monitoring - events - needed by event-based monitoring tools eg. Flower, celery events, celerymon

```shell
celery inspect
```

Remote control - ability to inspect + manage workers at runtime using commands or other tools using remote control API:

```shell
celery control
```

RabbitMQ is default broker, support in built:

```properties
broker_url = 'amqp://<user>:<password>@localhost:5432/myVHost'
```

```shell
docker run --rm --name rabbit rabbitmq
```

without --name rabbit:rabbit will resolve to some address on the internet:

```shell
docker run --rm --name celery --link rabbit:rabbit -v $pl:/pl bash
```

```shell
cd /pl; celery -A tasks worker --loglevel=info
```

```shell
docker exec -ti celery bash
```

or

```shell
docker-compose -f $pl/tests/docker/celery-docker-compose.yml up
```

## Celery App

my_tasks.py:

```python
from celery import Celery

# first arg is used to auto name tasks                    set rpc to collect results
app = Celery('myTasks', broker='pyamqp://guest@rabbit//', backend='rpc://')
# also works with broker='myamqp://' seems to default to guest@rabbit
#app = Celery('myTasks', broker='pyamqp://guest@rabbit//', rpc='rpc://')

@app.task
def add(x, y):
return x + y
```

```shell
celery worker --help
```

```shell
celery help
```

```shell
celery -A tasks worker --loglevel=info
```

```python
python
from tasks import add
result = add.delay(4, 4)
# see console of celery worker to see task execute + succeed
#
# NotImplementedError: No result backend configured.  Please see the documentation for more information.
# make sure app = Celery(... backend='rpc://')

# blocks + returns result value
num = result.wait()

# check whether task has finished
bool = result.ready()

# will raise exception if one encountered
num = result.get(timeout=1)
# suppress like so
result.get(propagate=False)

# if errored out
result.traceback
```

`celeryconfig.py` convention:

```python
app.config_from_object('celeryconfig')
```

`celeryconfig.py`:

```python
broker_url = 'pyamqp://'
result_backend = 'rpc://'

task_serializer = 'json'
result_serializer = 'json'
accept_content = ['json']
timezone = 'Europe/Oslo'
enable_utc = True

# route tasks to queue
task_routes = {
'tasks.add': 'low-priority',
}

# rate limit to only 10 of these tasks per minute
task_annotations = {
'tasks.add': {'rate_limit': '10/m'}
}
```

or control RabbitMQ/Redis brokers on the fly at runtime

```shell
celery -A tasks control rate_limit tasks.add 10/m
```

test the celeryconfig.py syntax

```shell
python -m celeryconfig
```

**Ported from private Knowledge Base page 2017+**
