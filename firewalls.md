# Firewalls

<!-- INDEX_START -->

- [Why You Need a Firewall](#why-you-need-a-firewall)
- [Hardware Firewalls](#hardware-firewalls)
  - [Cisco ASA (Adaptive Security Appliance)](#cisco-asa-adaptive-security-appliance)
  - [Fortinet FortiGate](#fortinet-fortigate)
  - [Palo Alto Networks PA-Series](#palo-alto-networks-pa-series)
  - [Check Point Firewalls](#check-point-firewalls)
  - [SonicWall TZ & NSa Series](#sonicwall-tz--nsa-series)
  - [Juniper SRX, Netscreen & SSG Series](#juniper-srx-netscreen--ssg-series)
  - [Barracuda CloudGen Firewall](#barracuda-cloudgen-firewall)
  - [WatchGuard Firebox](#watchguard-firebox)
  - [Sophos XG Firewall](#sophos-xg-firewall)
  - [Huawei USG Firewalls](#huawei-usg-firewalls)
- [Software Firewalls](#software-firewalls)
  - [Linux IPtables](#linux-iptables)
  - [nftables](#nftables)
  - [pf (Packet Filter)](#pf-packet-filter)
  - [UFW (Uncomplicated Firewall)](#ufw-uncomplicated-firewall)
  - [Firewalld](#firewalld)
  - [Windows Defender Firewall](#windows-defender-firewall)
  - [pfSense](#pfsense)
  - [IPFire](#ipfire)
  - [ClearOS](#clearos)
  - [Smoothwall Express](#smoothwall-express)
- [Cloud Software Firewalls](#cloud-software-firewalls)
  - [AWS Security Groups](#aws-security-groups)
  - [GCP Firewall](#gcp-firewall)
  - [Azure](#azure)

<!-- INDEX_END -->

## Why You Need a Firewall

Firewalls are there to restrict the number of TCP / UDP ports to the minimize attack surface of a computer system or
network of computer systems.

They are often used to limit source IP addresses to ensure some services can only be accessed from known good sites
(this is something that public websites cannot do obviously).

## Hardware vs Software Firewalls

Hardware firewalls are more expensive as they are invariably proprietary.

Software firewalls are often packaged with Operating Systems, but at industrial level usually only unix-based software
firewalls are used to protect other systems, most notably the widely used [Linux IPtables](#linux-iptables).

### Host vs Network Firewalls

Technically all firewalls operate on the same TCP/IP networking stack,
but some are more focused on protecting only their own computer host,
while others are routinely used
to protect other computer systems when using the host as a router forwarding packets acros the network.

Linux's IPtables is widely used for this purpose
and forms the basis of many cheaper appliances built on Linux such as [Smoothwall](#smoothwall).

## Hardware Firewalls

### Cisco ASA (Adaptive Security Appliance)

- Known for: Advanced threat protection, VPN capabilities, and deep packet inspection
- Used by: Large enterprises and service providers
- Features: Intrusion prevention, malware defense, and support for high-speed VPNs

### Fortinet FortiGate

- Known for: High performance, integrated threat protection, and SD-WAN capabilities
- Used by: Enterprises of all sizes
- Features: Next-Generation Firewall (NGFW), application control, VPN, and antivirus

### Palo Alto Networks PA-Series

- Known for: Threat prevention, deep visibility, and consistent protection across the network
- Used by: Large enterprises, data centers, and cloud environments
- Features: NGFW, advanced intrusion prevention, and malware protection

### Check Point Firewalls

- Known for: High throughput, advanced threat prevention, and unified security management
- Used by: Enterprises and data centers
- Features: Application control, threat prevention, URL filtering, and centralized management

### SonicWall TZ & NSa Series

- Known for: Affordable NGFW with high performance and advanced security features
- Used by: Small to medium-sized businesses (TZ) and larger enterprises (NSa)
- Features: Advanced threat detection, intrusion prevention, and VPN

### Juniper SRX, Netscreen & SSG Series

- Known for: Scalability, integration with SD-WAN, and advanced security services
- Used by: Enterprises, data centers, and service providers
- Features: NGFW, threat intelligence, application security, and VPN

### Barracuda CloudGen Firewall

- Known for: Built-in cloud integration and protection, especially for hybrid cloud deployments
- Used by: Enterprises looking for strong cloud security
- Features: Advanced threat detection, URL filtering, and centralized management

### WatchGuard Firebox

- Known for: User-friendly interface, affordable NGFW for small and mid-sized businesses
- Used by: SMBs and mid-market companies
- Features: Unified Threat Management (UTM), advanced malware detection, and VPN

### Sophos XG Firewall

- Known for: Easy integration with other Sophos products and synchronized security for endpoint protection
- Used by: Small and medium-sized businesses
- Features: NGFW, deep packet inspection, advanced threat detection, and web filtering

### Huawei USG Firewalls

- Known for: High performance and integration with Huawei's cloud and enterprise infrastructure
- Used by: Large enterprises, especially in Asia
- Features: Threat prevention, VPN, application control, and high availability

## Software Firewalls

### Linux IPtables

- Known for: Packet filtering, NAT (Network Address Translation), and firewall capabilities built into the Linux kernel
- Used by: Linux-based servers, networking environments, and embedded systems
- Features: Stateful packet inspection, traffic filtering based on IP addresses, ports, and protocols

### nftables

- Known for: Modern replacement for iptables in Linux, with more flexibility and easier management
- Used by: Linux-based systems as an alternative to iptables
- Features: Enhanced performance, stateful and stateless packet filtering, NAT, and better support for IPv6

### pf (Packet Filter)

- Known for: Robust firewall software for BSD-based systems like OpenBSD, FreeBSD, and NetBSD
- Used by: BSD-based systems and firewalls like pfSense
- Features: Stateful packet filtering, NAT, traffic normalization, and bandwidth control

### UFW (Uncomplicated Firewall)

- Known for: User-friendly command-line interface for managing iptables rules on Ubuntu and other Linux distributions
- Used by: Linux desktop and server environments
- Features: Simplified firewall configuration, with support for IPv6 and application profiles

### Firewalld

- Known for: Dynamic firewall management tool with support for network zones and services
- Used by: Red Hat-based Linux distributions (eg. CentOS, Fedora)
- Features: Easy management of rules, dynamic rules reloading, and support for IPv4, IPv6, and Ethernet bridging

### Windows Defender Firewall

- Known for: Built-in firewall for Windows operating systems
- Used by: Home and business environments on Windows PCs
- Features: Stateful packet filtering, integration with Windows security features, and support for inbound and outbound
  traffic rules

### pfSense

- Known for: Open-source firewall and router software based on FreeBSD and pf
- Used by: Small to medium-sized businesses, home users, and IT enthusiasts
- Features: Stateful packet filtering, VPN support, traffic shaping, and integrated web interface

### IPFire

- Known for: Open-source firewall and router solution with focus on security and performance
- Used by: Small businesses and home users
- Features: Stateful firewall, VPN, Intrusion Detection System (IDS), and traffic management

### ClearOS

- Known for: Easy-to-use Linux distribution with integrated firewall and network security tools
- Used by: Small businesses and IT enthusiasts
- Features: Stateful firewall, gateway antivirus, content filtering, and VPN

### Smoothwall Express

- Known for: Free and open-source firewall software designed for small businesses and home users
- Used by: Home networks and small office environments
- Features: Web-based management interface, traffic monitoring, VPN support, and proxy server integration

## Cloud Software Firewalls

Each [Cloud](cloud.md) provider has its own software firewalls.

### [AWS](aws.md) Security Groups

### [GCP](gcp.md) Firewall

### [Azure](azure.md)
