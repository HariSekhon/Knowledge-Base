# Mac

The best laptop money can buy:

https://www.apple.com/uk/macbook-pro/

If you don't have an M3 Pro / Max - you're missing out on an excellent (but overpriced) machine.

## Homebrew - Package Management

The best most widely used package manager for Mac in the world.

See [brew.md](brew.md) for how to use it and great package lists I've spent years discovering and building up.

## Commands

List disks:

```shell
diskutil list
```

## Service Management

Load and start a service from a `plist` file:

```shell
sudo launchctl load -F "/System/Library/LaunchDaemons/$name.plist"
sudo launchctl start "com.apple.$name"
```

Stop and unload a service:

```shell
sudo launchctl stop "com.apple.$name"
sudo launchctl unload "/System/Library/LaunchDaemons/$name.plist"
```

See [dhcp.md](dhcp.md) for a practical example of using this for the built-in tftp server for PXE boot installing Debian off your Mac.

## Creating Bootable USBs

Macs and many computers don't come with CD/DVD any more to save space, so you can either buy an external USB dvd-writer or create bootable USBs.

To create a bootable USBs from ISO image files intended for CD/DVDs in order to use them to install Linux
or use a disk wiping distro like DBAN or ShredOS,
you can download [Etcher](https://etcher.balena.io/) or use
[mac_iso_to_usb.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/mac_iso_to_usb.sh)
from [DevOps-Bash-tools](devops-bash-tools.md):

```shell
mac_iso_to_usb.sh "$iso"  # /dev/disk4
```

###### Ported from various private Knowledge Base pages 2010+
