# Performance Engineering

<!-- INDEX_START -->

- [CPU](#cpu)
- [RAM / Memory](#ram--memory)
  - [OOM Killer - Out of Memory Killer](#oom-killer---out-of-memory-killer)
- [Disk](#disk)
- [Linux CLI tools](#linux-cli-tools)
  - [APM - Application Performance Management](#apm---application-performance-management)
  - [Hunting down elusive sources of I/O wait](#hunting-down-elusive-sources-of-io-wait)

<!-- INDEX_END -->

## CPU

- clock speed is the single threaded performance speed. For single threaded applications this really matters. `gzip -9 some_huge_file` and see for yourself.
- cores are the number of CPU lanes on chip or combined on all CPU chips on a motherboard. This affects the number of parallel applications that can be run at the same time, as well as the performance of an app that is properly multi-threaded (most aren't that parallelized because the programming gets complicated). It's mainly because you want many apps running without waiting for others.
- [Von Neumann architecture](https://en.wikipedia.org/wiki/Von_Neumann_architecture) - CPU instructions and data cannot be retrieved at the same time due to shared buses. This is a performance bottleneck especially in modern computers where the CPU is faster than RAM access as the CPU has to wait for the data transfer to CPU chip, and made worse via bus contention in multiprocessor systems
- [NUMA architecture](https://en.wikipedia.org/wiki/Non-uniform_memory_access) - separate RAM to CPU buses in multiprocessor systems to avoid one CPU from causing congestion bottleneck to another CPU's RAM access
- high CPU % usage by anti-virus on Windows can be caused by scanning lots of small file changes
  - example Azure DevOps agent on Windows doing Docker build with this in Dockerfile: `COPY --from=builder node_modules .` (NodeJS directory full of small library files)
    - Fix/Workaround: configure the anti-virus software to not scan the CI/CD agent workdir where Docker is building - this resulted in speed up from 2 hours build timeout to 2 minutes!

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

### OOM Killer - Out of Memory Killer

Linux specific algorithm in the linux kernel that activates when out of both physical RAM and swap - it finds the app taking up the most memory and kills it to save the rest of the OS and other applications.

Sometimes this will kill a misbehaving runaway process that is hogging more RAM than it should.

But often that killed app was the main big app that you want to run on a server!

However, it's still usually the better option than the entire system seizing up and becoming unresponsive as you can just restart the application, and a seized up computer often requires a hard power cycle which is the worst option.

There is however the risk of data loss of unflushed data buffers as it's essentially a `kill -9` without warning to the app, but no worse than a hard power cycle.

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

## Linux CLI tools

```shell
lsof
```

```shell
strace
```

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

```none
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

**Ported from various private Knowledge Base pages 2010+**
