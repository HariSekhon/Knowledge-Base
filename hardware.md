# Hardware

## Dell

### DRAC - Dell Remote Access Controller

Hardware card with a second networking interface and IP address for out-of-bounds management of a server
and remote hardware and console to recover servers.

https://www.dell.com/en-uk/lp/dt/open-manage-idrac

Default user is `root`, default password is `calvin`.

```shell
ssh root/calvin@<drac_ip>
```

Change the DRAC admin password:

```shell
racadm config -g cfgUserAdmin -o cfgUserAdminPassword -i 2 $new_passwd
```

Run a check against your DRACs to ensure their passwords are changed:

in [HariSekhon/Nagios-Plugins](https://github.com/HariSekhon/Nagios-Plugins):

[check_ssh_login.pl](https://github.com/HariSekhon/Nagios-Plugins/blob/master/check_ssh_login.pl) - written specifically to automatically test my server fleets for any remaining default passwords, an inherited check on every server added to Nagios or any [compatible enterprise monitoring system](https://github.com/HariSekhon/Nagios-Plugins#enterprise-monitoring-systems).

#### `racadm` Commands

```shell
racadm serveraction hardreset
```
```shell
racadm serveraction gracereboot
```
```shell
racadm serveraction graceshutdown
```
```shell
racadm serveraction powercycle
```
```shell
racadm serveraction powerup
```
```shell
racadm serveraction powerdown
```

```shell
omreport chassis [memory]
```

###### ported from private Knowledge Base page 2010+
