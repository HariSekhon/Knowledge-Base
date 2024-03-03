# Monitoring

- active API checks - the gold standard most don't know
- port checks
- protocol checks
- metrics & variations

## Nagios

See [nagios-plugins.md](nagios-plugins.md)

## Metrics

- OpenTSDB - see [opentsdb.md](opentsdb.md)


#### Collectl

from EPEL:

```shell
yum install -y collectl
```

Configure for Graphite
```shell
sed -i.bak -e 's/^DaemonCommands/#DaemonCommands/g' /etc/collectl.conf
sed -i -e 's/^#DaemonCommands/a DaemonCommands = -f \/var\/log\/collectl -P -M -scdmnCDZ --export graphite,localhost:2003,p=os,s=cdmnCDZ' /etc/collectl.conf
```

Start service:

```shell
service collectl restart
```
