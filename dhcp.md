# DHCP

Dynamic Host Configuration Protocol - broadcasts for an IP address on the local LAN network at layer 2 using Mac addresses.

A DHCP server receives this and responds with an IP address from its preconfigured pool of IP addresses.

This IP lease is usually for 24 hours. If the client renews it before the expiry it keeps the address, otherwise the IP
returns to the pool and will be reassigned to another client when it requests an IP.

<!-- INDEX_START -->
- [DHCP Clients](#dhcp-clients)
  - [DHClient](#dhclient)
- [DHCP Servers](#dhcp-servers)
  - [ISC DHCPd](#isc-dhcpd)
- [DHCP Test Clients](#dhcp-test-clients)
  - [DHCPing](#dhcping)
- [DHCPdump](#dhcpdump)
- [Mac DHCP Server + PXE boot install Debian Linux](#mac-dhcp-server--pxe-boot-install-debian-linux)
  - [Run DHCP to point to your TFTP Server for PXE boot](#run-dhcp-to-point-to-your-tftp-server-for-pxe-boot)
- [dhcpd.conf](#dhcpdconf)
- [for ISC dhcpd](#for-isc-dhcpd)
- [ignore this](#ignore-this)
- [public DNS - you don't need to change this](#public-dns---you-dont-need-to-change-this)
- [If this DHCP server is the official DHCP server for the local](#if-this-dhcp-server-is-the-official-dhcp-server-for-the-local)
- [network, the authoritative directive should be uncommented.](#network-the-authoritative-directive-should-be-uncommented)
- [XXX: Edit IPs](#xxx-edit-ips)
  - [Download Debian netinstall to TFTP for PXE boot](#download-debian-netinstall-to-tftp-for-pxe-boot)
  - [Start TFTP](#start-tftp)
<!-- INDEX_END -->

## DHCP Clients

### DHClient

https://linux.die.net/man/8/dhclient

```shell
dhclient
```


## DHCP Servers

### ISC DHCPd

https://www.isc.org/dhcp/

Available on Linux and Mac.

Battle tested but deprecated.

Being replaced by Kea

https://www.isc.org/dhcp_migration/

## DHCP Test Clients

### DHCPing

Install on Mac:

```shell
brew install dhcping
```

Without specifying the expected `-s` it seems to get no answer. I'm sure this behaviour was different on Linux back in the day... or perhaps I'm thinking of a different DHCP testing client...

```shell
sudo dhcping -s 192.168.1.254
```

output:

```
Got answer from: 192.168.1.254
```

## DHCPdump

```shell
brew install dhcpdump
```

```shell
sudo dhcpdump -i en0
```

## Mac DHCP Server + PXE boot install Debian Linux

### Run DHCP to point to your TFTP Server for PXE boot

Install ISC DHCPd:

```shell
brew install isc-dhcp
```

Remind yourself of the start commands and config location later if you need it:

```shell
brew info isc-dhcp
```

Create a file `/opt/homebrew/etc/dhcpd.conf` with contents like this, change the IP addresses to suit your needs:
```shell
# dhcpd.conf
#
# for ISC dhcpd

# ignore this
option domain-name "hari.org";
# public DNS - you don't need to change this
option domain-name-servers 4.2.2.1, 4.2.2.2;

allow booting;
allow bootp;

default-lease-time 600;
max-lease-time 7200;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

log-facility local7;

# XXX: Edit IPs
subnet 192.168.1.0 netmask 255.255.255.0 {
  range dynamic-bootp 192.168.1.3 192.168.1.253;  # XXX: Edit
  option routers 192.168.1.254;  # XXX: Edit
  filename       "/pxelinux.0";
  next-server    192.168.1.89;  # XXX: Edit
}
```

Run `dhcpd` in the foreground for a little while:

```shell
sudo /opt/homebrew/opt/isc-dhcp/sbin/dhcpd -f -cf /opt/homebrew/etc/dhcpd.conf en0
```

### Download Debian netinstall to TFTP for PXE boot

from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
debian_netinstall_pxesetup.sh
```

This sets up `/private/tftpboot` directory with the Debian stable distribution.

### Start TFTP

You can start it manually on the command line or download [TftpServer](https://download.cnet.com/tftpserver/3000-2648_4-35651.html) to easily start/stop the built-in Mac tftp server via a GUI.

Start the the tftp server which will serve out `/private/tfpboot`.

##### WARNING: TFTP is unauthenticated and accessible to anybody on the network, do not put anything in there that is sensitive and do not run it longer than you have to

You can also start the TFTP server manually:

#### Manual CLI Method

Ensure the file `/System/Library/LaunchDaemons/tftp.plist` exists with this contents:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Disabled</key>
    <true/>
    <key>Label</key>
    <string>com.apple.tftpd</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/libexec/tftpd</string>
        <string>-i</string>
        <string>/private/tftpboot</string>
    </array>
    <key>inetdCompatibility</key>
    <dict>
        <key>Wait</key>
        <true/>
    </dict>
    <key>InitGroups</key>
    <true/>
    <key>Sockets</key>
    <dict>
        <key>Listeners</key>
        <dict>
            <key>SockServiceName</key>
            <string>tftp</string>
            <key>SockType</key>
            <string>dgram</string>
        </dict>
    </dict>
</dict>
</plist>
```

Start tftpd:

```shell
sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
sudo launchctl start com.apple.tftpd
```

At this point you can PXE boot and install off the network.

When done, stop tftpd:

```shell
sudo launchctl stop com.apple.tftpd
sudo launchctl unload /System/Library/LaunchDaemons/tftp.plist
```
