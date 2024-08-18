# Keepalived

VRRP IP failover daemon.

<!-- INDEX_START -->
- [Key Points](#key-points)
- [Test Keepalived in the foreground](#test-keepalived-in-the-foreground)
- [Linux: allow binding to IP of VIP from Keepalived](#linux-allow-binding-to-ip-of-vip-from-keepalived)
- [Example Config](#example-config)
<!-- INDEX_END -->

## Key Points

- VRRP - Virtual Router Redundancy Protocol
- can manage VIP as well as IPVS and real servers configuration
- designed for LVS / IPVS (Linux Virtual Server project)
- used in OpenStack

## Test Keepalived in the foreground

```shell
keepalived -f /etc/keepalive/keepalived.conf -D -N -l
```

| Switch | Description   |
|--------|---------------|
| -n     | foreground    |
| -D     | detail        |
| -l     | log to stdout |
| -C     | check syntax  |

## Linux: allow binding to IP of VIP from Keepalived

Add to `/etc/sysctl.conf`:
```
net.ipv4.ip_nonlocal_bind = 1
```

Reload sysctl settings:

```shell
sysctl -p
```

## Example Config

In `/etc/keepalive/keepalived.conf`:

```
global_defs {
  #router_id myHostname           # defaults
  #default_interface eth0
  #vrrp_version 2                 # could set 3
  #vrrp_mcast_group4 224.0.0.18   # IPv4
  #vrrp_mcast_group6 ff02::12     # IPv6
  vrrp_priority  0                # -19 to 20, lower is higher
  check_priority 0
  vrrp_no_swap                    # monitor these processes are still alive
  checker_no_swap

  snmp_socket udp:x.x.x.x:705
  enable_traps

  script_user hari                # default: keepalived_script else root
  enable_script_security          # don't run scripts as root if any part of the path is writeable by non-root user

  notification_email { # TO
      me@domain.com
      team@domain.com
  }
  notification_email_from root@server
  smtp_server x.x.x.x [<port>]
  # defaults:
  #smtp_helo_name myHostname
  #smtp_connect_timeout 30
}

vrrp_script myScriptSection {
  #script "/path/to/myscript.py <params>"
  script "killall -0 haproxy"  # detect if haproxy is still running, cheaper than 'pidof'
  # pkill -0 sshd
  interval 2          # default: 1
  timeout 2
  weight 10           # add 10 to priority if OK, -254 to 254, default: 0
  rise 2              # same as HAProxy, after rise successes => mark UP
  fall 3              # after fall failures => mark DOWN
  user hari [mygroup] # default uses primary group of user
  init_fail           # start in failed state
}

vrrp_instance inside_network {
  virtual_router_id 1  # unique id, 0 - 254, 0 didn't work in practice though
  state BACKUP         # or MASTER - but mostly useless as election happens anyway - keep as BACKUP on both to allow 'nopreempt'
  priority 100
  interface eth0
  nopreempt            # needs to be set to 'state BACKUP' to respect this
  # preempty_delay 300    # default:0, also needs 'state BACKUP'
  smtp_alert
  virtual_ipaddress {
  x.x.x.x/24 dev eth0 label eth0:1    # without label it won't show in 'ifconfig', only in 'ip addr show eth0' as a secondary hidden IP address
}
track_interface {
  eth0 weight -10  # remove 10 from prio if down
  eth1 # [weight -254 to 254 ]
  ...
}
track_script {
  myScriptSection  weight -10
  myScriptSection2 weight -10
}

# use in environments where multicast doesn't work, eg. AWS, a network in a bank (might need iptables -A INPUT -p vrrp -d 224.0.0.0/24 -j ACCEPT)
unicast_peer {
  x.x.x.x
  ...
}

authentication { # VRRPv2 removed auth, this is non-compliant
  auth_type AH # PASS is recommended but that is plaintext sniffable and exploitable using automated hacking tools like Loki
  auth_pass myPassword
  #use_vmac <mac>  # use virtual MAC if you want
}

fail internal + external VIPs together
vrrp_sync_group blah {
  group {
    internal_network
    outside_network
  }
  smtp_alert      # send email using global settings
}
```

###### Ported Knowledge Base page 2017+ - should have made notes on this in 2008-2010 but young guys don't document enough
