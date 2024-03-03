# Performance Engineering


lsof

strace


### APM - Application Performance Management

[AppDynamics](https://www.appdynamics.com/) and [New Relic](https://newrelic.com/) are the two most famous ones.

- agents embedded in the code of the app
- support for different frameworks out of the box
- follows from entry point all threads, JDBC calls etc and gives automatic diagram with stats, breakdowns, drilldowns to method calls taking time
- server can be SaaS or self-hosted

### Hunting down elusive sources of I/O wait

```shell
/etc/init.d/syslog stop
```
```shell
echo 1 > /proc/sys/vm/block_dump
```

```shell
dmesg |
grep -E "READ|WRITE|dirtied" |
grep -Eo '([a-zA-Z]*)' |
sort |
uniq -c |
sort -rn |
head
```

output:

```
1526 mysqld
819 httpd
429 kjournald
35 qmail
27 in
7 imapd
6 irqbalance
5 pop
4 pdflush
3 spamc
```

In my specific situation, it looks like MySQL is the biggest abuser of my disk, followed by Apache and the filesystem journaling. As expected, qmail is a large contender, too.

Don't forget to set things back to their normal state when you're done!

```shell
echo 0 > /proc/sys/vm/block_dump
```

```shell
/etc/init.d/syslog start
```

###### Ported from various private Knowledge Base pages 2010+
