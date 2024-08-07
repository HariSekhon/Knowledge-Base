# Networking

## CIDR visualizer

Shows bits, netmask, first IP, last IP, number of IPs in range

http://cidr.xyz/

## VPNs - Virtual Private Networks

Encrypt traffic between 2 locations.

SSL vs IPSec VPNs

2 forms:

- site-to-site VPNs - usually between two datacenters or an office and a datacenter
- client-to-site VPNs - usually between your desktop / laptop and the office or datacenter
  - consumer VPNs - these are client-to-site VPNs that are used to encrypt traffic so your ISP can't snoop on you, or to change your geographic location to watch Netflix or other streaming services that may not be available where you are physically located or may have restricted shows by country

### OpenVPN

[OpenVPN](https://openvpn.net/) is the open source standard for VPNs.

Several products are build on this open source base software and use it under the hood, eg. Tunnelblick.

#### OpenVPN Client

https://openvpn.net/client/

#### Tunnelblick

Standard open source GUI client on Mac that can connect to OpenVPN.

### Client VPNs

- [OpenVPN Client](https://openvpn.net/client/)
- [Perimeter 81](https://www.perimeter81.com/) - user friendly VPN

### Consumer VPNs

- [NordVPN](https://nordvpn.com/) - commercial well-established with a kill-switch to reduce risk of leakage
- TunnelBear - consumer VPN with free tier
- [Proton VPN](https://protonvpn.com/) - free to use privacy from your internet / wifi hotspot provider.
Pay for more features or server locations.
  This often breaks DNS resolution when connecting/disconnecting on Mac.
  Workaround:
```shell
dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```
If you are sourcing [DevOps-Bash-tools](devops-bash-tools.md) repo in your `.bashrc` there is a shell function
shortcut so you can just run: `flushdns`.

#### Fingerprinting

[fingerprint.com](https://fingerprint.com/) can still sort of identify you using a hash of common characteristics.
Click the link from Incognito/Private Browsing and on/off VPN to see

Documentation:

https://dev.fingerprint.com/

Open source library (TODO read this code):

https://github.com/fingerprintjs/fingerprintjs

## Commands

```shell
ping 4.2.2.1
```

### Show routing table

On Linux:

```shell
route -n
```

On Windows or Mac:

```shell
netstat -rn
```

### DNS lookup

Look up a well known public DNS address:

On Linux or Mac:

```shell
host google.com
```

On Windows:

```shell
nslookup google.com
```

### Add static route

[man route](https://linux.die.net/man/8/route)

```shell
route add ...
```

[man ip-route](https://man7.org/linux/man-pages/man8/ip-route.8.html)

```shell
ip route ...
```

### Show your public IP

...that you are NAT'd through as well as geolocation and other details:

```shell
curl ifconfig.co
```

### Linux - show your local IP Tables software firewall rules

```shell
iptables -nL -line-numbers
```
