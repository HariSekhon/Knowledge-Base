# Linux


### Cron

In RHEL 6

`/etc/cron.allow`

`/etc/cron.deny`

`/var/spool/cron` root:root 700

#### User Crons

Stored in `/var/spool/cron/$USER`.

`crontab` command is suid to allow user to manage it.

Opens the crontab in `$EDITOR` (default `vi` if `$EDITOR` environment variable is not set):

```shell
crontab -e
```

### DHCP

Install ISC DHCPd:

```shell
yum install -y dhcp
```

Edit config:

```shell
vim /etc/dhcp/dhcpd.conf
```

Enable it at boot:

```shell
systemctl enable dhcpd.service
```

Start the service:

```shell
systemctl start dhcpd.service
```

#### Test DHCP

Install `dhcping` tool:

```shell
yum install -y dhcping
```

Test DHCP response:

```shell
dhcping -s localhost
```

### CGroups

Limit resource usage.

This is used by modern containerization like `containerd` and [Docker](docker.md).

Can limit:

- CPU Time
- CPU core assignments
- Memory
- Devices
- Disk / Block I/O
- Network bandwidth

```shell
yum install -y libcgroup
```

```shell
service cgconfig start
```

```shell
ls /cgroup
```

```shell
lscgroup
```


Create cgroup - `/etc/cgconfig.conf`:
```
group blah {
  cpu {
    cpu.shares = 400;
  }
}
```

```shell
service cgconfig restart
```

then add processes (tasks) into cgroups according to parameters in the file:

`/etc/cgrules.conf`:
```
<user> <subsystems> <control_group>
@<group> <subsystems> <control_group>
<user>:<command> <subsystems> <control_group>
eg.
*:firefox cpu,memory browsers/
```

```shell
service cgred start
```

Sysconfig services can instead add this to their `/etc/sysconfig/<servicename>` file

```shell
CGROUP_DAEMON="<subsystem>:<control_group>"
```

### DRBD

- awesome disk replication, used this in the mid to late 2000s
- mainline Linux kernel now
- dual-primary (0.9+)
  - requires clustered filesystem (GFS, OCFS2)
- `mount -o ro` to avoid complexity of dual primary cluster filesystems
- sync + async repl options
- get check_drbd nagios plugin to see how far behind replica is, automatically catches up, low maintenance once set up


###### Ported from various private Knowledge Base pages 2002+
