# Kapacitor

Stream processing + alerting engine for TICK stack.

<!-- INDEX_START -->

- [Stream Pipeline](#stream-pipeline)
- [Kapacitor Enterprise](#kapacitor-enterprise)
- [CLI](#cli)
- [TICKscript](#tickscript)
- [Commands](#commands)

<!-- INDEX_END -->

Port: 9092 (conflicts with Kafka)

## Stream Pipeline

Option 1:

```text
Telegraf -> InfluxDB -> Kapacitor
```

Option 2:

```text
Telegraf -> Kapacitor
```

## Kapacitor Enterprise

- Clustering HA
- alert dedupe
- auth using InfluxDB meta nodes
- no authz yet (as of 1.4)

- subscribes to InfluxDB to forward all data to it (`influx> SHOW SUBSCRIPTIONS`)
- TICKscript - DSL language for how to process data (script.tick)
- task
- stream
- batch (InfluxDB query)

- send Telegraf to localhost:9092, use Kapacitor as drop in replacement for InfluxDB protocol endpoint

```shell
kapacitord config > kapacitor.conf
```

```text
/etc/kapacitor/kapacitor.conf
/var/log/kapacitor/kapacitor.log
```

```shell
export KAPACITOR_URL=http://kapacitor:9092
```

## CLI

```shell
kapacitor
```

## TICKscript

TICKscript can create running average + alert if CPU drops below 3 std deviations:

```text
crit(lambda: sigma("field") > 3)
```

## Commands

See docs for code contents:

```shell
kapacitor define cpu_alert -tick cpu_alert.tick
```

```shell
kapacitor list tasks
```

```shell
kapacitor show cpu_alert
```

take a sample to test with:

```shell
kapacitor record stream -task cpu_alert -duration 60s
```

```text
rid=xxxxxx-xxxxx...
```

```shell
kapacitor list recordings $rid
```

```shell
kapacitor replay_recordings $rid
```

```shell
kapacitor enable cpu_alert
```

```shell
kapacitor show cpu_alert
```

**Partial port from private Knowledge Base page 2018+**
