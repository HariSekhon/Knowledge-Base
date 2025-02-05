# RSyslog

<!-- INDEX_START -->

- [LogServer Forwarding](#logserver-forwarding)
- [Auditd Integration](#auditd-integration)
  - [RHEL v6 to v8 Config](#rhel-v6-to-v8-config)
  - [RHEL v9 Config](#rhel-v9-config)
- [Troubleshooting](#troubleshooting)
  - [Unknown builtin builtin_syslog](#unknown-builtin-builtin_syslog)

<!-- INDEX_END -->

## LogServer Forwarding

Configure RSyslog to forward logs to the logserver.

Edit `/etc/rsyslog.conf` to add this line:

```text
info.* @@<hostname_or_ip>
```

```shell
service rsyslog restart
```

Check that the server has network access to the logserver:

```shell
telnet x.x.x.x 514
```

## Auditd Integration

Install Auditd:

```shell
yum install audit audispd-plugins
service auditd start
chkconfig auditd on
```

Edit the `/etc/audisp/plugins.d/syslog.conf` file to set this line to activate the plugin:

```shell
active = yes
```

Restart Auditd for these changes to take effect:

```shell
service auditd restart
```

Check your Linux distro version:

```shell
cat /etc/*release
```

and then compare to the configs below:

### RHEL v6 to v8 Config

`/etc/audisp/plugins.d/syslog.conf` contents should look like this:

```text
active = yes
direction = out
path = builtin_syslog
type = builtin
args = LOG_INFO
format = string
```

### RHEL v9 Config

`/etc/audisp/plugins.d/syslog.conf` contents should look like this:

```text
active = yes
direction = out
path = /sbin/audisp-syslog
type = always
args = LOG_INFO
format = string
```

## Troubleshooting

Check messages for any issues after restarting Auditd.

### Unknown builtin builtin_syslog

If you see this error in the log:

```text
auditd[1962051]: Unknown builtin builtin_syslog
```

Then install the plugin:

```shell
yum install audispd-plugins
```

On RHEL9 the config is a bit different so restore it for compatibility:

```shell
cp /etc/audit/plugins.d/syslog.conf.rpmnew /etc/audit/plugins.d/syslog.conf
```

Then edit this line again:

```text
active = yes
```

Then compare to the complete configs for your RHEL version as shown above.

Then restart Auditd for changes to take effect:

```shell
service auditd restart
```
