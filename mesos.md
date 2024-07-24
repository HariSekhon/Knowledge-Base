# Mesos

Obsolete. Use [Kubernetes](kubernetes.md) instead.

Written in C++ with Java and Python bindings

- Marathon - task launcher, uses Docker
- Chronos  - cron (highly available, fault-tolerant)
- Mesos Consul - Docker image by Cisco that registers all services with Consul

| Port | Description          |
| ---- |----------------------|
| 5050 | Master UI            |
| 5051 | Slave                |
| 8080 | Cronos UI / REST API |


Each HA Master UI redirects to active master, so each master uses both a leader and detector to [ZooKeeper](zookeeper.md)

Industrial Light and Magic used Consul because Mesos DNS couldn't easily register docker containers outside Mesos cluster

- resource isolation using Cgroups and Docker
- Slave => resource offer (CPU, RAM, disk) => Master
- Master => resource offer => Scheduled App
- Allocation Module (pluggable) decides which App Framework to offer resources to

## Security

- Framework auth 0.15+ (basic shared secrets)
- Slave auth 0.19+
- SSL only protects Scheduler <-> Master data
- must encrypt Task data yourself
- future - HTTP Web UI auth

configure `--with-sasl=/path/to/sasl2`

master:

```
--authenticators  # default: crammd5
--credentials  # text/json file
--authenticate  # for frameworks
--authenticate_slaves
```

slave:

```
--authenticatee  # default: crammd5
--credential  # text/json file
```

## Setup

```shell
brew install autoconf automake libtool subversion maven
```

Not needed in newer versions of Mesos, mesos 0.21 failed to compile anyway

```
./configure --with-svn=/usr/local/Cellar/subversion/1.8.13
```

```shell
./configure
```

Compile with SSL:

```shell
./configure --enable-libevent --enable-ssl
```

Must also use:

```
SSL_ENABLED=1 SSL_KEY_FILE=key SSL_CERT_FILE=cert opt-flags binary
```

```shell
SSL_ENABLED=1 SSL_KEY_FILE=key SSL_CERT_FILE=cert SSL_REQUIRE_CERT=1 SSL_ENABLE_TLS_V1_1=true master.sh
```

```shell
make
```

```shell
make check
```

(optional)

```shell
make install
```

### Mesos CLI

```shell
pip install mesos.cli
```

```shell
mesos
```

From Mesos build:

```shell
mesos.sh # wrapper for Mesos commands
```

```shell
mesos-local.sh # run local mode pseudo cluster
```

```shell
mesos-tests.sh # run test suite
```

```shell
mesos-daemon.sh
```

```shell
mesos-start-cluster.sh
```

```shell
mesos-start-masters.sh
```

```shell
mesos-start-slaves.sh
```

list of hosts, uses SSH like Hadoop for mesos-start-cluster.sh etc scripts

```shell
$MESOS_HOME/var/mesos/deploy/masters
```

```shell
$MESOS_HOME/var/mesos/deploy/slaves
```

Can set any `MESOS_<OPTION_NAME>` env var:

```shell
export MESOS_MASTER # must specify port to prevent parsing localhost error
```

in .bashrc:

```shell
export MESOS_MASTER=localhost:5050
```

Use full path otherwise uses `/usr/local/bin/mesos` => `/usr/local/Cellar/mesos/0.23.0/bin/mesos`

Brew version (0.23)

```shell
mesos master --work_dir=/var/lib/mesos --log_dir=/tmp/mesos-master-logs --cluster=myCluster # --ip=127.0.0.1 # localhost fails to parse
```

```shell
mesos slave --master=127.0.0.1:5050 --log_dir=/tmp/mesos-slave-logs
```

Build version

```
--log_dir=$MESOS_HOME/logs # but couldn't find this in /usr/local/Cellar/mesos/0.23 nor /usr/local/mesos-0.24
```

```shell
$MESOS_HOME/src/mesos-master --work_dir=/var/lib/mesos --log_dir=/tmp/mesos-master-logs --cluster=myCluster
```

```
--authenticate        # for frameworks
--authenticate-slave
--ip --advertise_ip # if different to allow frameworks to connect
```

```shell
$MESOS_HOME/src/mesos-slave --log_dir=/tmp/mesos-slave-logs
```
```
--master=localhost:5050 # causes duplicate --master switch error when MESOS_MASTER defined
--attributes=rack:1,dc:2 --credentials=file:///path/to/file # where file contains "<username> <password>" or json '{ "principal"="hari", "secret"="blah" }'
--work-dir=/tmp/mesos # default
```

For HA Masters:

```shell
export ZKLIST=host1:2181,host2:2181,host3:2181
export ZKLIST=localhost:2181
$MESOS_HOME/src/mesos-master --work_dir=/var/lib/mesos --log_dir=/tmp/mesos-master-logs --cluster=myCluster --zk=zk://$ZKLIST/mesos
$MESOS_HOME/src/mesos-slave  --master=zk://$ZKLIST/mesos --log_dir=/tmp/mesos-master-logs
```

### Test frameworks to check Mesos is working

C++ - failed with TASK_LOST

```shell
$MESOS_HOME/src/test-framework --master=$MESOS_MASTER
```

Java (had to unset MESOS_NATIVE_LIBRARY):

```shell
$MESOS_HOME/src/examples/java/test-framework $MESOS_MASTER
```

Python:

```shell
$MESOS_HOME/src/examples/python/test-framework $MESOS_MASTER
```


## Chronos

- distributed Cron
- needs [ZooKeeper](zookeeper.md)
- UI port 8080 + REST API


```shell
zkServer.sh start
```

```shell
mesos-master --work_dir=/var/lib/mesos --log_dir=/tmp/mesos-master-logs --cluster=myCluster --ip=127.0.0.1 --zk=zk://localhost:2181/mesos --quorum=1
```

```shell
mesos-slave --log_dir=/tmp/mesos-slave-logs
```

```shell
git clone https://github.com/mesos/chronos.git
```

```
export MESOS_NATIVE_LIBRARY # (set in .bashrc based on Mac/Linux)
```
on Mac:

```shell
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/mesos/src/.libs/libmesos.dylib
```

on Linux (check this path):

```shell
export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/mesos/lib/libmesos.so
```

```shell
mvn package
```

```shell
java -cp target/chronos*.jar org.apache.mesos.chronos.scheduler.Main --master zk://localhost:2181/mesos
```

Used by BlackRock (talk 24/9/2015)

Mesos + Kubernetes on Mesos works but partial features

###### Ported from private Knowledge Base pages 2015+
