# Log4j

Classic logging library for Java

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Test Log4j config via quick code](#test-log4j-config-via-quick-code)
- [Set Log Levels](#set-log-levels)

<!-- INDEX_END -->

## Key Points

- Spark Log4j 1.2 was EOL 2015, June 2018 still there due to dependency hell
- Log4j 1.2
  - docs virtually nonexistent
  - `SocketAppender` doesn't respect `PatternLayout`
  - `TelnetAppender` appears to be read only socket
  - `SyslogAppender` does, but prefixes `<%{POSINT}>` and a space to every log
    - Logstash grok message replace to strip prefix, then mutate escape `\n`,`\r`,`\t`, then json parse in filter phase, not Syslog input codec

```shell
-Dlog4j.configuration=file:/path/to/log4j.properties
```

or

```properties
log4j.configurationFile=
```

In PatternLayout uses System Properties to enrich logs and differentiate jobs

- `${user.name}` - this is in JVM by default
- `${APPNAME}`   - feed via -D on command line
- `-DAPPNAME=blah`

SocketServer receives serialized SocketAppender logs

```shell
java -cplog4j-1.2-*.jar org.apache.log4j.net.SimpleSocketServer 4712 log4j.properties
```

## Test Log4j config via quick code

```shell
groovysh
```

```groovy
import org.apache.log4j.Logger

logger = Logger.getLogger("hari")

logger.info("test")
```

## Set Log Levels

Hadoop config:

```properties
hadoop.root.logger=INFO  # this is the default log level
```

Log4j config:

```properties
log4j.logger.any.specific.class.name=LEVEL
```

```properties
log4j.logger.any.package=LEVEL
```

eg:

```properties
log4j.logger.org.apache.hadoop.mapred=DEBUG
```

In  Code:

```properties
LOGGER.setLevel(Level.WARN);
```

**Ported from private Knowledge Base pages 2013+**
