# Fluentd

Log streaming agent by Treasure Data.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Ports](#ports)
- [Treasure Data distribution](#treasure-data-distribution)
- [Log locations](#log-locations)
- [Web UI](#web-ui)
- [Fluentular](#fluentular)
- [Fluent-cat](#fluent-cat)
- [Monitoring](#monitoring)
- [High Availability](#high-availability)
- [Config](#config)
  - [Source](#source)
  - [Fluentd Plugins](#fluentd-plugins)
    - [Install Plugins](#install-plugins)
    - [Update Plugins](#update-plugins)
  - [Input Plugins](#input-plugins)
  - [Parsers](#parsers)
  - [Output Plugins](#output-plugins)
    - [3rd Party Plugins](#3rd-party-plugins)
  - [Formatters](#formatters)
  - [Filters](#filters)
  - [Buffers](#buffers)
- [Fluent Bit](#fluent-bit)

<!-- INDEX_END -->

## Key Points

- versatile log collector written in C + Ruby
- 500+ plugins
- better performance and smaller memory footprint than [LogStash](logstash.md)
- treats logs in JSON
- scales (largest user 50,000+ servers)
- Ruby 2.1 + ruby-dev to build gem, or install rpm from Treasure Data repo
- spools buffer to disk - data loss only if disk is lost or proc dies in between receive + write to disk (flush interval)
- lot of new params in 0.14 eg. `@type tail`
- Fluentd => MongoDB tried by many users, doesn't scale well
- often used with [Elasticsearch](elasticsearch.md) and [Kibana](kibana.md) - called the EFK stack for each technology
  - can also be used with Prometheus
- often used in Kubernetes, cloud-native and [microservices](microservices.md) environments

DockerHub image:

```none
fluent/fluentd
```

Default username / password: `admin` / `changeme`

## Ports

| Port  | Service    | Type                  |
|-------|------------|-----------------------|
| 9292  | WebUI      | fluent-ui             |
| 9880  | HTTP API   | `@type http`          |
| 24220 | Rest API   | `@type monitor-agent` |
| 24224 | TCP forward| `@type forward`       |
| 24230 | Debug port | `@type debug_agent`   |

```shell
nmap -p 24224 -sU <host>
```

## Treasure Data distribution

```
td-agent
```

```none
/etc/td-agent/td-agent.conf
```

```shell
service td-agent
```

Validate config:

```shell
fluentd --dry-run -c fluent.conf
```

Capture Fluentd's own logs + send to logserver:

```none
<match fluentd.**>
...
```

## Log locations

```shell
/var/log/fluentd
/var/log/td-agent
```

## Web UI

Management & Regex Tester

Port 9292

```shell
fluent-ui start
```

or for Treasure Data distribution:

```shell
td-agent-ui start
```

## Fluentular

<http://fluentular.herokuapp.com>

Fluentd Regex Tester

- runs on Heroku free tier so might be unavailable some of the time, retry later

## Fluent-cat

```shell
fluent-cat [ -h 127.0.0.1 -p 24224 ] [ -u [ -s /var/run/fluent/fluent.sock] ]
```

```shell
echo '{"message": "hello"}' | fluentd-cat <mytag>
```

interact with debug port if enabled - see Monitoring section below for enabling `@type debug_agent`.

```shell
fluent-debug
```

## Monitoring

Rest API

Per plugin stats

```none
/api/plugins.json
```

```none
<source>
    @type   monitor_agent
    bind    0.0.0.0
    port    24220
</source>

fluent-debug command connects here
<source>
    @type   debug_agent
    bind    127.0.0.1
    port    24230
</source>
```

## High Availability

```none
<match **>
  @type   forward

  # primary
  <server>
    host    x.x.x.x
    port    24224
  </server>

  # backup
  <server>
    host    y.y.y.y
    port    24224
  </server>

  # reduces CPU usage large flush interval
  # <buffer>
  #   flush_interval 60s
  # </buffer>

</match>
```

## Config

Processes events top down as defined in config file.

`@plugin` - all plugins are prefixed with `@` symbol

| Component | Description                                                                                                                                                                                   |
|-----------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| source    | input, tags everything on inbound                                                                                                                                                             |
| match     | matches tag => sends to output plugin                                                                                                                                                         |
| filter    | pass / reject / modify some events based on @type or tag, can be used to add fields, or 'out_relabel' plugin to add new tag                                                                   |
| system    | system-wide config                                                                                                                                                                            |
| label     | groups outputs + filters for internal routing - `@label @blah` in <source> continues processing in `<label @blah>` section of filters + matches - must have `@` symbol at start of label name |
| @include  | include other files in lexical order <br> use multiple explicit @include to enforce ordering <br> `@include config./*.conf`                                                                   |
| tag       | dot separated components                                                                                                                                                                      |
| *         | match single event name component (dot delimited)                                                                                                                                             |
| **        | match zero or more event name components - use to match all logs or prefixed logs                                                                                                             |

```none
global settings
<system>
log_level       info
suppress_repeated_stackstace
process_name    myname  # ps will show 'worker:myname' and 'supervisor:myname'
```

### Source

- `@type` - which input plugin to use
  - `http` - http listener
  - `forward` - tcp listener
    - receives events from `24224/tcp`

This is used by log forwarding and the `fluent-cat` command:

```none
<source>
    @type forward
    port 24224
    @label @blah # processing continues in <label @blah> block
</source>
```

Send event with tag `my.app.tag`:

```none
http://this.host:9880/my.app.tag?json={"event":"data"}
```

```none
<source>
    @type http
    port 9880
</source>

<filter my.app.tag>
    @type record_transformer
    # add host_param field with Ruby hostname
    <record>
        host_param "#{Socket.gethostname}"
    </record>
</filter>
```

Matches in config file order, put more specific at top, otherwise they'll be consumed by more generic matches

Match events with tag `my.app.tag` + send to output plugin `file`:

```none
<match my.app.tag>
  @type file
  path /var/log/fluent/myapp.log
</match>
```

Match any of multiple whitespace separated tags:

```none
<match tag1 tag2>
```

Only events with `<source> @label @blah` go in to this block:

```none
<label @blah>

  <filter myprefix.**>
    @type grep
    ...
  </filter>

  <match **>
    @type s3
    ...
  </match>

</label>

<source>
    @type tail
    @id yarn_resourcemanager_input
    format multiline
    format_firstline /\d{4}-\d{1,2}-\d{1,2}/
    format1 /^(?<my_event_time>[^ ]* [^ ]*) (<?level>[^ ]*) (?<class>[^:]*) (?<message>.*)$/
    time_key my_event_time
    keep_time_key true
    path /opt/mapr/hadoop/hadoop-*/logs/yarn-*-resourcemanager-*.log
    tag resourcemanager
    pos_file /opt/mapr/fluentd/fluentd-0.14.00/var/log/fluentd/tmp/resourcemanager.pos
</source>

<store>
    @type remote_syslog
    host x.x.x.x
    port 51400
    severity debug
    tag fluentd
</store>
```

### Fluentd Plugins

Common Params:

| Attribute    | Description                                         |
|--------------|-----------------------------------------------------|
| `@type`      | Specifies the plugin                                |
| `@id`        | `plugin_id` field shown in `monitor_agent` Rest API |
| `@label`     |                                                     |
| `@log_level` | Per plugin log level                                |


#### Install Plugins

`fluent-gem` and `td-agent-gem` are wrappers around `gem` command.

Use these otherwise won't be able to find gems via OS or RVM commands.

```shell
fluent-gem   install fluent-plugin-grep
```

or for Treasure Data distribution:

```shell
tg-agent-gem install fluent-plugin-grep
```

Pin specific version for prod to avoid regressions:

```shell
fluent-gem install fluent-plugin-elasticsearch -v 2.4.1
```

```shell
fluentd -p /path/to/plugin -p /path/to/plugin2
```

Auto-loads plugins from:

```none
/etc/fluentd/plugin
```

or

```none
/etc/td-agent/plugin
```

`/etc/fluentd/Gemfile`:

```Gemfile
source 'http://rubygems.org'
gem 'fluentd-pluing-elasticsearch', '2.4.1'
gem ...
##
```

```shell
fluentd --gemfile /etc/fluentd/Gemfile
```

```shell
fluendtd -S
```

#### Update Plugins

Update plugins after updating Ruby as Ruby doesn't guarantee C extension compatibility between major versions
so plugins using C might break.

### Input Plugins

`@type`:

- tail
- forward (tcp)
- tcp (delimited, default: \n)
- udp
- http - POST
- syslog
- exec - interval or long running program - fluentd expects tsv, msgpack or json stdout
- dummy - generates events for testing
- windows_eventlog

### Parsers

Set in input `<sources>`

- extract fields from log `<key>` (eg. message)
- Fluent UI has Regex tester

- regexp - `(?<fieldname>regex)` - set fieldname to `time` to reset time of event from content, configurable by
  `time_key`
- apache2 - shows regex used in doc
- apache-error
- nginx
- syslog - socket text protocol parser
- LTSV - Labelled Tab Separated Values blah:val\tblah2:val2...
- CSV - provide array of keys as headers, delimiter
- TSV
- json - oj / yajl / json parser types (default: oj)
- multiline - multi-line version of regex parser
  - uses tstamp regex as delimiter + sends logs when next log is generated
  - `format_firstline /^\d{4}-\d{1,2}-\d{1,2}`
    `format1 /line1_regex/`  # capture different line formats that are part of the multi-line logs
    `format2 /line2_regex/`
    ...
- grok - github by fluent to allow grok patterns + pattern files

### Output Plugins

Strongly recommended to be set in any output match plugin to write when destination servers are unavailable
or buffers are full:

```none
<secondary>
    out_secondary_file /path/to/file
```

| Plugin              | Description                                                                                                                             |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `out_copy`          | Sends to 2 or more locations                                                                                                            |
| `out_exec`          | TSV stdin                                                                                                                               |
| `out_webhdfs`       | Hourly - to output, appends every 10 secs (hdfs-site.xml - need to set `dfs.support.append = true`, `dfs.support.broken.append = true`) |
| `out_s3`            |                                                                                                                                         |
| `out_forward`       | `<secondary>` is recommended in case other servers are unavailable                                                                      |
| `out_roundrobin`    |                                                                                                                                         |
| `out_stdout`        | For debugging, stdout in foreground / logs in daemon mode                                                                               |
| `out_exec_filter`   |                                                                                                                                         |
| `out_file`          |                                                                                                                                         |
| `out_mongo`         |                                                                                                                                         |
| `out_mongo_replset` |                                                                                                                                         |
| `out_none`          | Stores message in 'message' field to defer parsing for later                                                                            |
| `out_null`          |                                                                                                                                         |
| `out_relabel`       | Does nothing, just allows `@label @blah` to be added                                                                                    |

#### 3rd Party Plugins

- AWS
- GCP
- NoSQL
- Search - [Elasticsearch](elasticsearch.md) - user + password + ssl verify options for X-Pack authentication

### Formatters

Set in each output plugin:

| Format         | Description                                                   |
|----------------|---------------------------------------------------------------|
| `file`         | `<tstamp>\t<tag>\t<json>`                                     |
| `json`         |                                                               |
| `ltsv`         |                                                               |
| `csv`          |                                                               |
| `msgpack`      | MessagePack binary encoding, more efficient than JSON         |
| `hash`         | Dictionary                                                    |
| `single_value` | Output a single field, e.g., `message`, instead of all fields |
| `stdout`       | Time tag: `<json_msg>`                                        |

### Filters

| Filter                      | Description                                                                                                                                            |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `filter_record_transformer` | Add/mutate tags/message using Ruby `#{code_snippet}`                                                                                                   |
| `filter_record_modifier`    | Faster subset of common use cases                                                                                                                      |
| `filter_group`              | Filters only messages where key fields match regex                                                                                                     |
| `filter_parse`              | Parses given key field and adds fields to message's JSON (like LogStash grok)                                                                          |
| `filter_geoip`              | Adds fields using Maxmind GeoLite2 free geoip database (free but less accurate than their commercial version, uses geoip-devel rpm / libgeoip-dev deb) |
| `filter_stdout`             | Debugging                                                                                                                                              |

### Buffers

- file - dependent on the filesystem, don't use remote NFS, HDFS, GlusterFS etc.
- memory:

```none
  <match **>
  buffer_type file
  # buffer paths must have separate non-overlapping prefixes to not interfere with each other
  # as they are recursively collected - see doc for clarity
  buffer_path /var/log/fluent/myapp.*.buffer
  # * is replaced by random chars, could use ${tag} but must be unique between all fluentd instances
```

## Fluent Bit

DockerHub:

```none
fluent/fluent-bit
```

- fast lightweight log collector / forwarder (like Beats)
- `td-agent-bit` rpm / deb
- simpler ini config style

### Fluentbit vs Fluentd

| Fluentd                       | Fluentbit                                                    |
|-------------------------------|--------------------------------------------------------------|
| C & Ruby                      | C                                                            |
| ~ 40MB                        | ~ 450KB                                                      |
| Ruby gem, requires other gems | Zero dependencies (unless some special plugin requires them) |
| 650+ plugins                  | 35+ plugins                                                  |

**Ported from private Knowledge Base page 2017**
