# Performance Engineering

<!-- INDEX_START -->

- [Quick Dump All Stats](#quick-dump-all-stats)
  - [Dump Stats Locally](#dump-stats-locally)
  - [Dump Stats Across Servers Using SSH](#dump-stats-across-servers-using-ssh)
- [CPU](#cpu)
- [RAM / Memory](#ram--memory)
  - [OOM Killer - Out of Memory Killer](#oom-killer---out-of-memory-killer)
- [Disk](#disk)
  - [I/O](#io)
- [Network](#network)
- [System Calls](#system-calls)
- [APM - Application Performance Management](#apm---application-performance-management)
- [Hunting down elusive sources of I/O wait](#hunting-down-elusive-sources-of-io-wait)

<!-- INDEX_END -->

## Quick Dump All Stats

Using scripts from [DevOps-Bash-tools](devops-bash-tools.md) repo..

### Dump Stats Locally

```bash
dump_stats.sh
```

Generates:

```text
stats-bundle.YYYY-MM-DD-HHSS.tar.gz
```

If `export NO_REMOVE_STATS_DIR=1` is set,
then leaves the intermediate `stats-bundle.YYYY-MM-DD-HHSS` directory with text files.

### Dump Stats Across Servers Using SSH

```bash
ssh_dump_stats.sh "$server1" "$server2" "$server3"
```

Generates:

```text
server1.stats-bundle.YYYY-MM-DD-HHSS.tar.gz
server2.stats-bundle.YYYY-MM-DD-HHSS.tar.gz
server3.stats-bundle.YYYY-MM-DD-HHSS.tar.gz
```

## CPU

- clock speed is the single threaded performance speed. For single threaded applications this really matters. `gzip -9 some_huge_file` and see for yourself.
- cores are the number of CPU lanes on chip or combined on all CPU chips on a motherboard. This affects the number of parallel applications that can be run at the same time, as well as the performance of an app that is properly multi-threaded (most aren't that parallelized because the programming gets complicated). It's mainly because you want many apps running without waiting for others.
- [Von Neumann architecture](https://en.wikipedia.org/wiki/Von_Neumann_architecture) - CPU instructions and data cannot be retrieved at the same time due to shared buses. This is a performance bottleneck especially in modern computers where the CPU is faster than RAM access as the CPU has to wait for the data transfer to CPU chip, and made worse via bus contention in multiprocessor systems
- [NUMA architecture](https://en.wikipedia.org/wiki/Non-uniform_memory_access) - separate RAM to CPU buses in multiprocessor systems to avoid one CPU from causing congestion bottleneck to another CPU's RAM access
- high CPU % usage by anti-virus on Windows can be caused by scanning lots of small file changes
  - example Azure DevOps agent on Windows doing Docker build with this in Dockerfile: `COPY --from=builder node_modules .` (NodeJS directory full of small library files)
    - Fix/Workaround: configure the anti-virus software to not scan the CI/CD agent workdir where Docker is building - this resulted in speed up from 2 hours build timeout to 2 minutes!

Top is better on Linux than Mac:

```shell
top
```

Top snapshot on Linux:

```shell
top -H -b -n 1
```

```shell
mpstat -P ALL 1 5
```

## RAM / Memory

- Paging vs Swapping
  - paging is technically moving pages of memory between RAM and disk
  - swapping is used colloquially to mean the same thing but technically it means moving all pages of an application to disk
  - when a portion of the RAM an application is not using recently is moved by the operating system kernel offloaded to disk, and then later needed to be accessed, the OS must retrieve it back into working physical RAM. This is roughly 1000x slower than just using it from RAM, so doing this too often is very, very bad for performance and should be avoided in most cases
- Page faults / Hard faults - paging ram pages to/from disk - bad for performance, lots of page faults indicate there is not enough RAM

For best performance, one should never page/swap.

Disable swap / paging file on Windows if you have the RAM to spare - live fast or die hard.

If you have limited physical RAM then it can be valid to use swap partition / paging file (same thing Linux vs Windows) is a valid way of conserving your precious fast RAM by not having seldom accessed application data from hogging it and in those cases offloading to disk is the best you can do (the alternative would be crashing the app or OS).

<https://www.linuxatemyram.com/>

Linux commands:

```shell
free -g
```

```shell
vmstat 1 5
```

```shell
sar -u 1 5
```

```shell
sar -A
```

Mac commands:

```shell
memory_pressure
```

```shell
top -l 1 -stats pid,command,cpu,th,pstate,time,cpu -ncols 16 | head -n "$LINES"
```

### OOM Killer - Out of Memory Killer

Linux specific algorithm in the linux kernel that activates when out of both physical RAM and swap - it finds the app taking up the most memory and kills it to save the rest of the OS and other applications.

Sometimes this will kill a misbehaving runaway process that is hogging more RAM than it should.

But often that killed app was the main big app that you want to run on a server!

However, it's still usually the better option than the entire system seizing up and becoming unresponsive as you can just restart the application, and a seized up computer often requires a hard power cycle which is the worst option.

There is however the risk of data loss of unflushed data buffers as it's essentially a `kill -9` without warning to the app, but no worse than a hard power cycle.

You can see this in the kernel logs, try:

```shell
less /var/log/messages
```

```shell
dmesg
```

## Disk

- HDD
  - hard disk drives use spinning metal platters with magnetic heads that move to the inner or outer part of the disks as they spin
  - slow, fine for sequential I/O but bad for random I/O due to head seek times
  - these are the classic hard drives
  - very vulnerable to physical shocks such as dropping as well as magnets
- SDD
  - solid state drives are like big flash memory banks
  - faster, better for random I/O but with limited number of writes and wear out
  - more expensive / smaller sizes for the same money
  - use these if you have the money or care about performance

Show Used vs Available Disk Space in human readable units eg. MB or GB or TB:

```shell
df -h
```

If disk space isn't being removed after removing files, it's possible they are being held open by a running process.

To see open files:

```shell
lsof -n
```

(the `-n` switch skips DNS resolution to speed up the command
or prevent it from hanging temporarily trying to reverse resolve IP addresses to DNS FQDNs)

### I/O

```shell
iostat -c 5
```

Write test using `dd`:

```shell
dd if=/dev/zero of="/path/to/dir/file" bs=64m count=64 oflag=direct
```

## Network

See [Networking](networking.md) page for tools.

## System Calls

Linux:

```shell
strace "$program"
```

Mac:

```shell
dtruss -f "$program"
```

## APM - Application Performance Management

[AppDynamics](https://www.appdynamics.com/) and [New Relic](https://newrelic.com/) are the two most famous ones.

- agents embedded in the code of the app
- support for different frameworks out of the box
- follows from entry point all threads, JDBC calls etc and gives automatic diagram with stats, breakdowns, drilldowns to method calls taking time
- server can be SaaS or self-hosted

## Hunting down elusive sources of I/O wait

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

```text
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

In my specific situation, it looks like MySQL is the biggest abuser of my disk, followed by Apache
and the filesystem journaling. As expected, qmail is a large contender, too.

Don't forget to set things back to their normal state when you're done!

```shell
echo 0 > /proc/sys/vm/block_dump
```

```shell
/etc/init.d/syslog start
```

**Ported from various private Knowledge Base pages 2010+**
