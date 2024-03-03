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



###### Ported from private Knowledge Base page 2002+
