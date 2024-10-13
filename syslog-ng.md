# Syslog-Ng

Excellent well-established next generation syslog daemon written in C by Balabit.

<!-- INDEX_START -->

- [Key Points](#key-points)
- [Syslog-ng Tuning & Tips](#syslog-ng-tuning--tips)
  - [Match Log Rules Early](#match-log-rules-early)
  - [Aggregation vs Splitting](#aggregation-vs-splitting)
  - [Flow Control - Log Windows and Buffer Sizing](#flow-control---log-windows-and-buffer-sizing)
    - [Important Settings](#important-settings)
    - [Useful calculations](#useful-calculations)
  - [Disable power saving features](#disable-power-saving-features)

<!-- INDEX_END -->

## Key Points

- Highly configurable and flexible
- High performance & efficiency due to being written in C
- Extensible with a rich plugin system
- Good for large-scale high volume logging environments
- Good for distributed logging due to ability to use of TCP port 514 instead of traditional Syslog's lossy UDP 514

## Syslog-ng Tuning & Tips

### Match Log Rules Early

Use `/etc/syslog-ng.d/` and name the config files with the highest % matching `^0-` so they are processed first to
reduce the amount of CPU used in regex matching lines.

### Aggregation vs Splitting

Consider combining all web logs to `/var/log/network/web.log` or similar name so you can see all the web logs in one
place at one time.

This may be too busy to use interactively but may make post-processing via scripting easier.

### Flow Control - Log Windows and Buffer Sizing

Syslog-ng has flow control which buffers messages in memory.

When your servers and applications send more traffic than syslog-ng can handle, it will buffer the lines in memory until
it can process them. The alternative would be to drop the log lines, resulting in data loss.

#### Important Settings

- `log_fifo_size` - size of the output buffer. Each destination has its own one of these. If you set it globally, one buffer is created for each destination, of the size you specify.
- `log_iw_size` - initial size of the input control window. Syslog-ng uses this as a control to see if the destination buffer has enough space before accepting more data. Applies once to each source (not per-connection!)
- `log_fetch_limit` - number of messages to pull at a time from each source. Applies to every connection of the source individually.
- `max_connections` - maximum number of TCP connections to accept

Each of your servers shouldn't open more than one TCP connection to your central syslog server.

**Make sure you set `max_connections` to more than your number of servers.**

#### Useful calculations

To know what to set for `log_iw_size` and `log_fifo_size`:

```text
log_iw_size = max_connections * log_fetch_limit
```

```text
log_fifo_size = log_iw_size * (10~20)
```

Syslog-ng will fetch at most:

```text
log_fetch_limit * max_connections
```

messages each time it polls the sources.

Your `log_fifo_size` should be able to hold many polls before it fills up.

When your destination (file on disk or another syslog server) is not able to accept messages quickly enough,
they will accumulate in the `log_fifo buffer`, so make this BIG.

```text
log_fifo_size = (log_iw_size = max_connections * log_fetch_limit) * 20
```

### Disable power saving features

Disable power saving features for Syslog-ng and [Nagios](nagios.md) as they are high context switching applications.

<br>

**Ported from private Knowledge Base page 2012+** (should have kept notes 2007+)**
