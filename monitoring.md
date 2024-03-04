# Monitoring

- active API checks - the gold standard most don't know
- port checks
- protocol checks
- metrics & thresholds - deviations from normal

## Nagios

See [nagios-plugins.md](nagios-plugins.md)

## Metrics

### OpenTSDB

See [opentsdb.md](opentsdb.md)

### Collectl

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

### Ganglia

Simple but old now, used to use for clusters like Hadoop in 2009.

- `gmetad` - server
- `gmond`  - agent

Port 8649


### Geneos

Proprietary Monitoring System.

- agent "netprobes", pre-configured checked + metrics, CPU, disk space etc
- sample rate eg. 60 secs
- CSV output with header columns, shows CSV table on UI
- gateway == collection / hosting server
- on gateway configure matches / thresholds on the column cells to raise alerts
- Windows "ActiveConsole" UI app connects to N gateways to monitor
- configure checks on gateway
- shell script exit 1 loses the stdout/stderr? This makes no sense, double check this is true from this old note
- can't run Nagios Plugins (I did write an [adapter](https://github.com/HariSekhon/Nagios-Plugins/blob/master/adapter_geneos.py) for its format)
- wouldn't recommend using it unless you had no other choice - this is legacy enterprise software
- used by 3 financials I worked at - which if you know old financials you'll know is not a flex
