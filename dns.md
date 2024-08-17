# DNS - Domain Name System

Resolves hostnames and fully qualified domain names (FQDNs) to IP addresses.

<!-- INDEX_START -->
- [Ports](#ports)
  - [DNS Server Software](#dns-server-software)
  - [Public DNS Servers for Clients](#public-dns-servers-for-clients)
  - [Misc](#misc)
  - [Linux Packages for DNS Clients](#linux-packages-for-dns-clients)
  - [DNSmasq on macOS](#dnsmasq-on-macos)
  - [DNSMasq on RHEL7](#dnsmasq-on-rhel7)
  - [DDNS - Dynamic DNS](#ddns---dynamic-dns)
<!-- INDEX_END -->

## Ports

| TCP / UDP | Port | Description                                                            |
| --------- | ---- |------------------------------------------------------------------------|
| UDP       | 53   | - DNS client requests<br/>- DNS server replies                         |
| TCP       | 53   | - Dynamic DNS<br/>- Zone transfers between DNS servers for replication |

### DNS Server Software

- [ISC Bind](https://www.isc.org/bind/) - the classic unix DNS - still runs most of the internet
- [DjbDNS / TinyDNS](https://cr.yp.to/djbdns.html) - smaller faster DNS server
- [DNSmasq](https://thekelleys.org.uk/dnsmasq/doc.html) - simple, serves `/etc/hosts` as DNS records
  - good for local labs or small local networks
- [InfoBlox](https://www.infoblox.com/) - enterprise DDI (DNS, DHCP, IPAM - IP Address Management) and threat protection - see [infoblox.md](infoblox.md) TODO

#### Lab DNS - Create FQDNs with embedded IP addresses

https://sslip.io/ - maps anything `<anything>[.-]<IP Address>.sslip.io` in either 'dot' or 'dash' notation to the embedded IP address.

https://nip.io - maps `<anything>[.-]<IP Address>.nip.io` in either 'dot' or 'dash' notation to the embedded IP address.

Commonly used for labs and demos where you need to put hostnames / FQDNs in software configuration instead of IP addresses.


### Public DNS Servers for Clients

Public DNS servers available for clients to use:

- `1.1.1.1` - Cloudflare - privacy first DNS
- `8.8.8.8` - Google DNS servers (as if they don't track you enough)
- `8.8.4.4` - Google DNS servers
- `208.67.222.222` - OpenDNS
- `208.67.220.220` - OpenDNS

### Misc

TSIG key - shared key for one-way hash auth for DDNS and zone transfers

DNS Security - see [security.md](security.md)

### Linux Packages for DNS Clients

Contains the `host` and `dig` commands:

```shell
sudo yum install -y bind-utils
```

### DNSmasq on macOS

```shell
brew install dnsmasq
```

To configure dnsmasq, copy the example configuration to `/usr/local/etc/dnsmasq.conf`
and edit.

```shell
cp /usr/local/opt/dnsmasq/dnsmasq.conf.example /usr/local/etc/dnsmasq.conf
```

```shell
vim /usr/local/etc/dnsmasq.conf
```

Sample config I used to use in labs to only serve local VirtualBox VMs -
only listens on `vboxnet0` interface and contains `*.local` lookups:

```
local=/dev/
local=/local/
local=/localdomain/
local=//
interface=vboxnet0
bind-interfaces
```

To have launchd start dnsmasq at startup:

```shell
sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
```

Then to load dnsmasq now:

```shell
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
```




### DNSMasq on RHEL7

```shell
sudo yum install -y dnsmasq
```

```shell
dnsmasq --test
```

```shell
sudo systemctl enable dnsmasq
```

```shell
sudo systemctl start dnsmasq
```

Test DHCP response:

```shell
sudo yum install -y dhcping
```

```shell
sudo dhcping -s localhost
```

### DDNS - Dynamic DNS

Requires TCP port 53

http://www.semicomplete.com/articles/dynamic-dns-with-dhcp/

http://www.debian-administration.org/articles/591

```shell
nsupdate -v -k /etc/bind/admin-updater.key
```

```shell
> update delete www.example.com cname
> send

> update add www1.example.com 86400 a 172.16.1.1
> update add www.example.com 600 cname www1.example.com.
> send
```

###### Ported from private Knowledge Base page 2010+ - should have had notes going back to 2003 but young guys don't document enough
