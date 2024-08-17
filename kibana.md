# Kibana

Port 5601

- query bar will search any field
- `message: Exception`  - searches `message` field for word `Exception`, can surround with `*` wildcard
- select only specific field - in bar on left click `add` next to available fields
- date picker top right
- add indexes - left bar Management -> Index Patterns -> top left Plus +

<!-- INDEX_START -->
- [Kibana 3](#kibana-3)
  - [Rsyslog config snippet addition](#rsyslog-config-snippet-addition)
- [this is for index names to be like: logstash-YYYY.MM.DD](#this-is-for-index-names-to-be-like-logstash-yyyymmdd)
- [this is for formatting our syslog in JSON with @timestamp](#this-is-for-formatting-our-syslog-in-json-with-timestamp)
- [this is where we actually send the logs to Elasticsearch (localhost:9200 by default)](#this-is-where-we-actually-send-the-logs-to-elasticsearch-localhost9200-by-default)
<!-- INDEX_END -->

# Kibana 3

```shell
git clone https://github.com/elasticsearch/kibana.git
cd kibana
```

Edit `config.js` to point to ElasticSearch server otherwise it assumes local system.

```shell
$EDITOR config.js
```

Serve these files with any web server:

```shell
python -m SimpleHTTPServer
```

Click:

```
bottom left -> Event fields
top left    -> auto-refresh
top middle  -> Save as My Default
```

### Rsyslog config snippet addition

Kibana expects logstash format so mimic it with Rsyslog

TODO: Rsyslog queues in case ElasticSearch is down

http://wiki.rsyslog.com/index.php/Queues_on_v6_with_omelasticsearch

Json formatted logging

http://blog.sematext.com/2013/05/28/structured-logging-with-rsyslog-and-elasticsearch/


Documentation: http://www.rsyslog.com/doc/omelasticsearch.html

```
module(load="omelasticsearch") # for outputting to Elasticsearch

# this is for index names to be like: logstash-YYYY.MM.DD
template(name="logstash-index" type="list") {
  constant(value="logstash-")
  property(name="timereported" dateFormat="rfc3339" position.from="1" position.to="4")
  constant(value=".")
  property(name="timereported" dateFormat="rfc3339" position.from="6" position.to="7")
  constant(value=".")
  property(name="timereported" dateFormat="rfc3339" position.from="9" position.to="10")
}

# this is for formatting our syslog in JSON with @timestamp
template(name="plain-syslog" type="list") {
  constant(value="{")
  constant(value="\"@timestamp\":\"")     property(name="timereported" dateFormat="rfc3339")
  constant(value="\",\"@host\":\"")        property(name="hostname")
  constant(value="\",\"@severity\":\"")    property(name="syslogseverity-text")
  constant(value="\",\"@facility\":\"")    property(name="syslogfacility-text")
  constant(value="\",\"@syslogtag\":\"")   property(name="syslogtag" format="json")
  constant(value="\",\"@message\":\"")    property(name="msg" format="json")
  constant(value="\"}")
}

# this is where we actually send the logs to Elasticsearch (localhost:9200 by default)
action(type="omelasticsearch"
  server="172.16.1.85"
  template="plain-syslog"
  searchIndex="logstash-index"
  dynSearchIndex="on"
)
```

###### Ported from private Knowledge Base pages 2013+
