# Linux

<!-- INDEX_START -->
  - [Shell](#shell)
  - [Cron](#cron)
  - [Timezone](#timezone)
  - [Networking](#networking)
  - [IPtables](#iptables)
  - [DHCP](#dhcp)
  - [CGroups](#cgroups)
  - [Disk Management](#disk-management)
  - [DRBD](#drbd)
- [Distributions](#distributions)
  - [Gentoo](#gentoo)
- [#emaint -a sync](#emaint--a-sync)
<!-- INDEX_END -->

### Shell

[Shell](shell.md) - the command line program with some scripting constructs that calls the binary programs in
`/bin`, `/usr/bin` and similar directories.

Start with [Bash](bash.md) which is the standard open source Linux shell.

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

### Timezone

This affects the cron scheduling above and recorded dates of jobs eg. data loading and recording.

For modern Linux systems with systemd:

```shell
timedatectl list-timezones
```

Servers should usually be set to UTC for consistent easy comparison across international systems unless this affects
data loading dates from cron above.

```shell
timedatectl set-timezone UTC
```

### Networking

See [Networking](networking.md) doc.

### IPtables

Top for iptables, awesome!

```shell
iptstate
```

List rules with line numbers:

```shell
iptables -nL -line-numbers
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

### Disk Management

List disk space of mounted partitions:

```shell
df -h
```

List partitions:

```shell
cat /proc/partitions
```

Format a spare partition:

```shell
mkfs.ext4 /dev/sda2
```

Check and recover filesystem, replay journal, prompts for fixes:

```shell
fsck /dev/sda2
```

Mount a filesystem to the directory `/data`:

```shell
mount /dev/sda2 /data
```

### DRBD

- awesome disk replication, used this in the mid to late 2000s
- mainline Linux kernel now
- dual-primary (0.9+)
  - requires clustered filesystem (GFS, OCFS2)
- `mount -o ro` to avoid complexity of dual primary cluster filesystems
- sync + async repl options
- get check_drbd nagios plugin to see how far behind replica is, automatically catches up, low maintenance once set up

## Distributions

[Debian](debian.md) is the standard open source distribution, and it's derivative [Ubuntu](ubuntu.md).

[Redhat](redhat.md) used to the standard enterprise distro but has killed its open source credentials and become legacy.

Gentoo is discussed below

### Gentoo

Compiles packages from source using Portage package manager.

If you tune the compilation settings and have the patience to wait for it, this creates the most elite systems,
ultra customized and noticeably snappier.

Downside is that you spend your life compiling software.
When you go to [Debian](debian.md) it's shocking how quick it is to install packages and get on with your life...


Fetch the package list from mirrors via rsync:

```
#emaint -a sync
emerge --sync
```

Sync via http tarball download (faster for first time sync, use with docker):

```shell
emerge-webrsync
```

Search packages:

```shell
emerge -s "$term"
```

There is now a `net-analyzer/nagios-check_glsa2` package.

I ran elite desktops, laptops, and server fleet on Gentoo in the 2000s for 5 years

My boss was highly technical good quality high class guy who was pro this because we had CPU-bound processing servers
so this made them go faster, and so I rebuilt and standardized the entire server fleet on Gentoo.

I'd  really love to build elite personal desktops and laptops again - the height of nerdiness :)

Alas, Macs are just quicker to get on with the day job...

###### Ported from various private Knowledge Base pages 2002+
